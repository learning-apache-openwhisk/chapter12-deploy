BEGIN {
    print "  - path: " file
    print "    permissions: 0755"
    print "    content: |" 
}
{
    print "          " $0
}
