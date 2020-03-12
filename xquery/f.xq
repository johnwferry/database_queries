

<result>
{
  for $member in /congress/committees/committee/member and /congress/committees/committee/subcommittee/member
      $person in /congress/people/person
  where $person/@id = $member/@id
  order by $person/@name
  return
    <member>{data($person/@name)} </member>
  }
</result>
