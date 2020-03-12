<result>
{
  for $committee in /congress/committees/committee,
      $member in $committee/member,
      $person in /congress/people/person
  where $committee/@code = "HSAG"
    and $member/@role = "Vice Chair"
    and $person/@id = $member/@id
  return $person
}
</result>
