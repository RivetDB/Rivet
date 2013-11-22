﻿using System;

namespace Rivet.Operations
{
	public sealed class RemoveExtendedPropertyOperation : Operation
	{
		// Schema
		public RemoveExtendedPropertyOperation(string schemaName, string name)
		{
			ForSchema = true;
			SchemaName = schemaName;
			Name = name;
		}

		// Table or View
		public RemoveExtendedPropertyOperation(string schemaName, string tableViewName, string name, bool forView)
		{
			if (forView)
				ForView = true;
			else
				ForTable = true;
			SchemaName = schemaName;
			TableViewName = tableViewName;
			Name = name;
		}

		// Column
		public RemoveExtendedPropertyOperation(string schemaName, string tableViewName, string columnName, string name, bool forView)
		{
			if (forView)
				ForView = true;
			else
				ForTable = true;
			ForColumn = true;
			SchemaName = schemaName;
			TableViewName = tableViewName;
			ColumnName = columnName;
			Name = name;
		}

		public bool ForSchema { get; private set; }
		public bool ForTable { get; private set; }
		public bool ForView { get; private set; }
		public bool ForColumn { get; private set; }
		public string SchemaName { get; private set; }
		public string TableViewName { get; private set; }
		public string ColumnName { get; private set; }
		public string Name { get; private set; }

		public override string ToIdempotentQuery()
		{
			var level1Type = "null";
			var level1Name = "null";
			var level2Type = "null";
			var level2Name = "null";

			if (ForTable)
			{
				level1Type = "'TABLE'";
				level1Name = string.Format("'{0}'", TableViewName);
			}

			if (ForView)
			{
				level1Type = "'VIEW'";
				level1Name = string.Format("'{0}'", TableViewName);
			}

			if (ForColumn)
			{
				level2Type = "'COLUMN'";
				level2Name = string.Format("'{0}'", ColumnName);
			}

			return
				string.Format(
					"if exists (select * from fn_listextendedproperty ('{0}', 'schema', '{1}', {2}, {3}, {4}, {5})){6}\t{7}",
					Name, SchemaName, level1Type, level1Name, level2Type, level2Name, Environment.NewLine, ToQuery());
		}

		public override string ToQuery()
		{
			var query = string.Format("exec sys.sp_dropextendedproperty @name=N'{0}',{2}@level0type=N'SCHEMA', @level0name=N'{1}'", Name, SchemaName, Environment.NewLine);

			if (ForTable)
			{
				query += string.Format(",{1}                                 @level1type=N'TABLE', @level1name='{0}'", TableViewName, Environment.NewLine);
			}

			if (ForView)
			{
				query += string.Format(",{1}                                 @level1type=N'VIEW', @level1name='{0}'", TableViewName, Environment.NewLine);
			}

			if (ForColumn)
			{
				query += string.Format(",{1}                                 @level2type=N'COLUMN', @level2name='{0}'", ColumnName, Environment.NewLine);
			}

			return query;
		}
	}
}
