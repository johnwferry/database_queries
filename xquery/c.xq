

<result>
{
  for $person in /congress/people/person,
      $role in $person/role
  where $person/@gender = "F"
    and $role/@current = "1"
    and xs:date($person/@birthday) >= xs:date("1980-01-01")
  order by $person/@name
  return
    <female name="{$person/@name}" type="{$role/@type}"> </female>
}
</result>
