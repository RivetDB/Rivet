﻿using System;

namespace Rivet.Operations
{
	public sealed class RemoveDefaultConstraintOperation : TableObjectOperation
	{
		public RemoveDefaultConstraintOperation(string schemaName, string tableName, string columnName, string name)  
			: base(schemaName, tableName, name)
		{
			ColumnName = columnName;
		}

		public string ColumnName { get; set; }

		public override string ToIdempotentQuery()
		{
			return String.Format("if object_id('{0}.{1}', 'D') is not null{2}\t{3}", SchemaName, Name, Environment.NewLine, ToQuery());
		}

		public override string ToQuery()
		{
			return string.Format("alter table [{0}].[{1}] drop constraint [{2}]", SchemaName, TableName, Name);
		}
	}
}
