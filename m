Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbaGaDOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 23:14:16 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33993 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbaGaDOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 23:14:15 -0400
Message-ID: <53D9B482.8070306@gmail.com>
Date: Wed, 30 Jul 2014 23:14:10 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Work Queue for btrfs compression writes
References: <CAPDOMVjJHbCwDVyKQ+Vuse7G76FLSLq69Ja4kmopDbjtEb_Zkw@mail.gmail.com>	<CA+WRLO9HdX=PDktUci2bQNM0Wp6DsjxiiWBNAxOtvitPqWDCAg@mail.gmail.com> <CAPDOMVjxx0WXVXVrMLgO1FimHNrJTn0Dp14G9_dXhSrm32WyBQ@mail.gmail.com>
In-Reply-To: <CAPDOMVjxx0WXVXVrMLgO1FimHNrJTn0Dp14G9_dXhSrm32WyBQ@mail.gmail.com>
X-Enigmail-Version: 1.6
OpenPGP: id=85D2EC0F
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070701070708020003070408"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms070701070708020003070408
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/30/2014 12:54 AM, Nick Krause wrote:
> On Wed, Jul 30, 2014 at 12:37 AM, Gareth Pye <gareth@cerberos.id.au> wr=
ote:
>> You've been replied to politely, now listen and do or shut up.
>>
>>
>> On Wed, Jul 30, 2014 at 1:54 PM, Nick Krause <xerofoify@gmail.com> wro=
te:
>>>
>>> Hey Guys ,
>>> I am new to   reading  and writing  kernel code.I got interested in
>>> writing code for btrfs as it seems to
>>> need more work then other file systems and this seems other then
>>> drivers, a good use of time on my part.
>>> I interested in helping improving the compression of btrfs by using  =
a
>>> set of threads using work queues like XFS
>>> or reads and keeping the page cache after reading compressed blocks a=
s
>>> these seem to be a great way to improve
>>> on  compression performance mostly with large partitions of compresse=
d
>>> data. I am not asking you to write the code
>>> for me but as I am new a little guidance and help would be greatly
>>> appreciated as this seems like too much work for just a newbie.
>>> Thanks A lot,
>>> Nick
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>>
>> --
>> Gareth Pye
>> Level 2 Judge, Melbourne, Australia
>> Australian MTG Forum: mtgau.com
>> gareth@cerberos.id.au - www.rockpaperdynamite.wordpress.com
>> "Dear God, I would like to file a bug report"
>=20
> Gareth
> I am asking for advice on not writing the code but can someone please
> test this for me as I don't have many hard drives lying around. In addi=
tion
> I am new to btrfs , so I would like to known if this is a good idea or =
should
> I just drop it?
> Nick
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20
I would look into using usermode linux (linux built with ARCH=3Dum) for a=
t
least the initial debugging, it is marginally more efficient than
virtualization, doesn't need root privileges, and allows you to run the
kernel under GDB without needing separate hardware with a serial console
or PS/2 keyboard.


--------------ms070701070708020003070408
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGuDCC
BrQwggScoAMCAQICAw8BRDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA1
MTIxNDEwMzJaFw0xNDExMDgxNDEwMzJaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDbLUaL
Gs4JTdU7sgr0MzD57CMUAv307ddC9pxooDMN3PiUvzEd5kLtBCh8KDB1wbMdfm4hte2rDd+j
hM1tIq67BvNbdDPztOcBZwT2/3OVyyG4B1ddCqUyt03zGKw6Y34eHNfapsZiiItX0GBNfjHU
Wv+WDo+XNha/WmGSSMv21HkftF9XA1KC9Bpr9JJI23MKK7T2g/7b3KoGZlx3ekLIJsF5B7+B
DMPPDqOHQbRnccyOHEMyhM13g6WoAbU+3aKYc+C/9UsYtDV+xlvBLWagky1acstD5wOA35V6
uDRbUhD+vOjuMRMCj9jJOIYqa6AeSagBjxRnisJr0RFzQ4f+NjGCHPaFTvRvbkiXh4q22doT
0SxbNBUm7B9ANugIOtS9/VQhTWKDi//WTqZQ7Ecl4yVJbMCUg/iaRHMCGS41vqMICPszRidW
rL04NwS9D2cREEY1y/xrNo0ZvKPZu6tLhxhPf7w+5rsN3+wWxGaR1hNpnVUT9AeacLKZO6W9
FsRT3Unkr91IhQATHTKYr4EAkjN/5lgvA+sxp5TxxsUnoJYrD8IHf8aYfJsAHMleBwx4xSeZ
tw/n5iIjJjFZq9IRZ1zQhK62p+a5vJ2vlJHjTgavhQrfb1pUOjbqsnI4ndQ5hNosL9el4Kxq
Yko+HsxVEmSwSsjq6cV2L3oz0z8NUwIDAQABo4IBWTCCAVUwDAYDVR0TAQH/BAIwADBWBglg
hkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFIGhlYWQg
b3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYDVR0PAQH/BAQDAgOoMEAGA1UdJQQ5
MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4
QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9y
ZzAxBgNVHR8EKjAoMCagJKAihiBodHRwOi8vY3JsLmNhY2VydC5vcmcvcmV2b2tlLmNybDA0
BgNVHREELTArgRRhaGZlcnJvaW43QGdtYWlsLmNvbYETYWhlbW1lbGdAb2hpb2d0LmNvbTAN
BgkqhkiG9w0BAQ0FAAOCAgEAIokFPcW8+cO2Clu0Ei+ehAmQRBHfV5RWJ8aMVLXOCfiJX0ch
IjVSIt6I3uQaR4J1ZIAjCSPkbpfZQDaLoGFI5j8aYEQhOeKxrvOMzY9/aSUYabCJIhE/sX64
klFV0bzm+PR9cDMWeQ9BoZf0m8UROPSfDnrjEk+p04hGg3pAZMcSwCzxdb604NHjgHJmf2xG
UQVzQgC6Ek/BKat0xuPTuPmtPv9OicK75CPmLZKYW3rFpCD6bhb1mm+ROcCNhniRY2LYm9YN
QdlHQUzTFqj0tvuYrzNI3LNV4PjEfN8z6omPCT2Rq8/uKLseN+m8F0ioqm+cphqpmzKoDUpN
nePLkqDFUFWCeWRxSjBTy4IMVUfdNXriVGihH8hyIICQiOfmmBOzhzUifdomJuTGtoXRuHVT
R2f/YdrJrLnKI4f+Othdp7F3KhB4c6JiOnTEH5J8n9q3rFjt4MPRwcjIHMhmF5nZVQlgxEMo
1cPCmvG1D9tcgXbH79jjqydo9SDXhzLQob7axkzGRY96IstNcvoQ/UNsdPPfFMYlHtGz4TxT
DhBjv4ERskGmKBZrfmxkXkcuTV/gcykct6Xvw9YXb8WTL4qSYHSYk9fReVLgE/L4RBUpX2JJ
QvIR0AJLER165/aZlQXZtuJjnfxJtJTJZZ+Gor9h0G2kuR5Dy0JuYdBO4t4xggShMIIEnQIB
ATCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5v
cmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEW
EnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFEMAkGBSsOAwIaBQCgggH1MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDczMTAzMTQxMFowIwYJKoZIhvcNAQkE
MRYEFKMkwWSpLHAulfQjtZxfl9xcxOycMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICACCQRutlAauYrPlaJ+Z/QfO42Pk+bv4luMKx06hNE8L6cMmJ
LxyOqrO6DG1Aca2bzj8gzuhh8yBAbC3wyUSoItIvnGoYgtX6b01oTNmjWnU8bM/mzGvp9JVi
ucDiZYn+HrfULskJc4RhanINExDeP+iL1kuNhRmNdS+qsXcT3u3Me6l2wIO7YaQspYSE7SWo
wsdeDIZQnfM18XtLHzUH8z2CPv0JpHSLH7f5q5ySOsMpIz1SA6Q0Awltp0nLTIxOGRvHejsL
F8Mi4A54J/EI4NF+t4QnsUsEUGoAxatW1D3e3dgZafTgvdDn4eTtg9ZuVblJlP4J6S4AsLmm
RbNQGkiBtRAkiM2B9CTvHx2eAjEHfkq18V3CSd+p+En3ZN3lMl59DZEL3tukpXkhQaZsP7a9
2i3+/zgzFtI2+MPklPJenri+ZRqBOrhEm+UaeUP0dNm2bHDO8d2iHFyr7gm47IyFMNsETj8x
0IUFnmZ0oEKmyTJrtmdBrh8B10wOqycEeP0fti8YLw9zID4Ech6gPNKRDur/jmS1UZHSbWJ+
G0nm8q/57LhMSpdGYAVoMJ31qPROoYbBFnhasPv2Hy8mbEMOQwo5BJr+dbvgclbDH3GzIxbH
ZYesAJ9mmtLrLXhPYLPvHvLLydUq8SoyR0mLIif+4DAeqqwwKZeg9fr3VHNHAAAAAAAA
--------------ms070701070708020003070408--
