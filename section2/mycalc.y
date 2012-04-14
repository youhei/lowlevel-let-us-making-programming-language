%{
#include <stdio.h>
#include <stdlib.h>
#define YYDEBUG 1
%}
%union {
  int int_value;
  double  double_value;
}
%token <double_value> DOUBLE_LITERAL
%token ADD SUB MUL DIV CR
%type <double_value> expression term primary_expression
%%
line_list /* 「行並び」とは... */
  : line  /* (ひとつの)行、 */
  | line_list line  /* または、「行並び」の後ろに「行」を並べたもの。 */
  ;
line  /* 「行」とは... */
  : expression CR /* 式の後ろに改行を入れたもの。 */
  {
    printf(">>%lf\n", $1);
  }
  | error CR
  {
    yyclearin;
    yyerrok;
  }
expression  /* 「式」とは... */
  : term  /* 「項」、 */
  | expression ADD term   /* または、「式」+「項」 */
  {
    $$ = $1 + $3;
  }
  | expression SUB term   /* または、「式」-「項」 */
  {
    $$ = $1 - $3;
  }
  ;
term  /* 「項」とは、 */
  : primary_expression  /* 「一次式」、*/
  | term MUL primary_expression   /* または、「項」*「一次式」 */
  {
    $$ = $1 * $3;
  }
  | term DIV primary_expression   /* または、「項」/「一次式」 */
  {
    $$ = $1 / $3;
  }
  ;
primary_expression  /* 「一次式」とは */
  : DOUBLE_LITERAL  /* 実数のリテラル */
  ;
%%
int
yyerror(char const *str)
{
  extern char *yytext;
  fprintf(stderr, "parser error near %s\n", yytext);
  return 0;
}

int main(void)
{
  extern int yyparse(void);
  extern FILE *yyin;

  yyin = stdin;
  if (yyparse()) {
    fprintf(stderr, "Error ! Error ! Error !\n");
    exit(1);
  }
}
