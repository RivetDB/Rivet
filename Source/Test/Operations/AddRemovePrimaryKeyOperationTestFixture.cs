﻿using NUnit.Framework;
using Rivet.Operations;

namespace Rivet.Test.Operations
{
	[TestFixture]
	public sealed class AddRemovePrimaryKeyOperationTestFixture
	{
		[SetUp]
		public void SetUp()
		{

		}

		[Test]
		public void ShouldSetPropertiesForAddPrimaryKey()
		{
			var schemaName = "schemaName";
			var tableName = "tableName";
			string [] columnName = new string[] { "column1", "column2" };
			string[] smokeColumn = new string[] { "column1" };
			bool nonClustered = true;
			string[] options = new string[] { "option1", "option2" };
			string[] smokeoptions = new string[] { "option1" };

			var op = new AddPrimaryKeyOperation(schemaName, tableName, columnName, nonClustered, options);
			Assert.AreEqual(schemaName, op.SchemaName);
			Assert.AreEqual(tableName, op.TableName);
			Assert.AreEqual(columnName, op.ColumnName);
			Assert.AreNotEqual(smokeColumn, op.ColumnName);
			Assert.AreEqual(nonClustered, op.NonClustered);
			Assert.AreEqual(options, op.Options);
			Assert.AreNotEqual(smokeoptions, op.Options);
		}

		[Test]
		public void ShouldWriteQueryForAddPrimaryKey()
		{
			var schemaName = "schemaName";
			var tableName = "tableName";
			string[] columnName = new string[] { "column1", "column2" };
			bool nonClustered = true;
			string[] options = new string[] { "option1", "option2" };

			var op = new AddPrimaryKeyOperation(schemaName, tableName, columnName, nonClustered, options);
			var expectedQuery = "alter table [schemaName].[tableName] add constraint PK_schemaName_tableName_column1_column2 primary key nonclustered (column1,column2) with ( option1, option2 )";
			Assert.AreEqual(expectedQuery, op.ToQuery());
		}

		[Test]
		public void ShouldWriteQueryWithDifferentSettingsForAddPrimaryKey()
		{
			var schemaName = "dbo";
			var tableName = "tableName";
			string[] columnName = new string[] { "column1" };
			bool nonClustered = false;

			var op = new AddPrimaryKeyOperation(schemaName, tableName, columnName, nonClustered, null);
			System.Console.WriteLine(op.ToQuery());
			var expectedQuery = "alter table [dbo].[tableName] add constraint PK_tableName_column1 primary key clustered (column1)";
			Assert.AreEqual(expectedQuery, op.ToQuery());
		}
	}
}
