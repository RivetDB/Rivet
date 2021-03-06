﻿using NUnit.Framework;
using Rivet.Operations;

namespace Rivet.Test.Operations
{
	[TestFixture]
	public sealed class EnableConstraintOperationTestFixture
	{
		[Test]
		public void ShouldInitializeOperation()
		{
			const string schemaName = "schema";
			const string tableName = "table";
			const string constraintName = "name";
			var op = new EnableConstraintOperation(schemaName, tableName, constraintName, true);
			Assert.That(op.Name, Is.EqualTo(constraintName));
			Assert.That(op.SchemaName, Is.EqualTo(schemaName));
			Assert.That(op.TableName, Is.EqualTo(tableName));
			Assert.That(op.WithNoCheck, Is.True);
			Assert.That(op.ToQuery(),
				Is.EqualTo(string.Format("alter table [{0}].[{1}] check constraint [{2}]", schemaName, tableName, constraintName)));
		}
	}

}