

<result>
{
  for $person in /congress/people/person,
      $role in $person/role
  where $role/@state = "NC"
    and $role/@current = "1"
    and $role/@type = "rep"
  order by number($role/@district)
  return
    <representative name="{$person/@name}" district="{$role/@district}" party="{$role/@party}"> </representative>
}
</result>
