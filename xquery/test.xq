

<result>
{
  let $mid := //*[contains(name(), 'committee')]/*[name()='member'],
      $p in /congress/people/person
  where (every $id in $p//id satisfies $id != $mid/id)
  return <member> {$p/@id} </member>
  }
</result>
