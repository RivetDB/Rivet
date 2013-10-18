﻿using System;
using NUnit.Framework;
using Rivet.Operations;
using System.Collections;

namespace Rivet.Test.Operations
{
	[TestFixture]
	public sealed class UpdateRowOperationTestFixture
	{
		private const string SchemaName = "schemaName";
		private const string TableName = "tableName";
		private const string Where = "City = 'San Diego'";
		private UpdateRowOperation op;

		private static readonly Hashtable SanDiego = new Hashtable
		{
			{"State", "Oregon"},
			{"Population", 1234567}
		};

		[SetUp]
		public void SetUp()
		{
		}

		[Test]
		public void ShouldSetPropertiesForUpdateSpecificRows()
		{
			GivenConditionalRowsToUpdate(SanDiego, Where);
			Assert.AreEqual(SchemaName, op.SchemaName);
			Assert.AreEqual(TableName, op.TableName);
			Assert.AreEqual(SanDiego, op.Column);
			Assert.AreEqual(Where, op.Where);
			Assert.IsFalse(op.All);
		}

		[Test]
		public void ShouldSetPropertiesForUpdateAllRows()
		{
			GivenRowsToUpdate(SanDiego);
			Assert.AreEqual(SchemaName, op.SchemaName);
			Assert.AreEqual(TableName, op.TableName);
			Assert.AreEqual(SanDiego, op.Column);
			Assert.IsTrue(op.All);
		}

		[Test]
		public void ShouldWriteQueryForUpdateSpecificRows()
		{
			GivenConditionalRowsToUpdate(SanDiego, Where);
			ThenQueryValuesAndWhereClauseAre("Population = 1234567, State = 'Oregon'", "City = 'San Diego'");
		}

		[Test]
		public void ShouldWriteQueryForUpdateAllRows()
		{
			GivenRowsToUpdate(SanDiego);
			ThenQueryValuesAre("Population = 1234567, State = 'Oregon'");
		}

		[Test]
		public void ShouldNotEscapeColumns()
		{
			GivenRawRows(SanDiego);
			ThenQueryValuesAre("Population = 1234567, State = Oregon");
		}

		[Test]
		public void ShouldFormatNumberValue()
		{
			var value = 1;
			GivenRowsToUpdate(new Hashtable { { "name", value } });
			ThenQueryValuesAre(string.Format("name = {0}", value));
		}

		[Test]
		public void ShouldFormatDateTimeValue()
		{
			var value = new DateTime(2013, 10, 18, 10, 06, 00);
			GivenRowsToUpdate(new Hashtable { { "name", value } });
			ThenQueryValuesAre(string.Format("name = '{0}'", value));
		}

		[Test]
		public void ShouldFormatTimeSpanValue()
		{
			var value = new TimeSpan(10, 7, 00);
			GivenRowsToUpdate(new Hashtable { { "name", value } });
			ThenQueryValuesAre(string.Format("name = '{0}'", value));
		}

		[Test]
		public void ShouldFormatBooleanValue()
		{
			var value = true;
			GivenRowsToUpdate(new Hashtable { { "name", value } });
			ThenQueryValuesAre("name = 1");
		}

		[Test]
		public void ShouldFormatStringValue()
		{
			GivenRowsToUpdate(new Hashtable { { "name", "McDonald's" } });
			ThenQueryValuesAre("name = 'McDonald''s'");
		}

		[Test]
		public void ShouldFormatNullValue()
		{
			GivenRowsToUpdate(new Hashtable { { "name", null } });
			ThenQueryValuesAre("name = null");
		}

		private void GivenRowsToUpdate(Hashtable rows)
		{
			op = new UpdateRowOperation(SchemaName, TableName, rows, false);
		}

		private void GivenConditionalRowsToUpdate(Hashtable rows, string @where)
		{
			op = new UpdateRowOperation(SchemaName, TableName, rows, where, false);
		}

		private void GivenRawRows(Hashtable rows)
		{
			op = new UpdateRowOperation(SchemaName, TableName, rows, true);
		}

		private void ThenQueryValuesAre(string setClause)
		{
			var expectedQuery = string.Format("update [schemaName].[tableName] set {0}", setClause);
			Assert.AreEqual(expectedQuery, op.ToQuery());
		}

		private void ThenQueryValuesAndWhereClauseAre(string setClause, string whereClause)
		{
			ThenQueryValuesAre(setClause + " where " + whereClause);
		}

	}
}