

<result>
{
  for $person in /congress/people/person,
      $role in $person/role
  where $person/role/@type = "rep"
    and $role/@current = "1"
    and $role/@type = "sen"
  order by $person/@name
  return
    <member>{data($person/@name)} </member>
  }
</result>
