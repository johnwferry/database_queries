<result>
  {
    for $person in /congress/people/person
    where ends-with($person/@name, "Price")
    return $person
  }
</result>
