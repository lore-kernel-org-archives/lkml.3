Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaIERJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:09:31 -0400
Received: from cernmx13.cern.ch ([188.184.36.46]:19818 "EHLO CERNMX13.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbaIERJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:09:29 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2014 13:09:28 EDT
From: Arne Wiebalck <Arne.Wiebalck@cern.ch>
To: Peter Kieser <peter@kieser.ca>, "eddie@ehuk.net" <eddie@ehuk.net>,
        "Jens Axboe" <axboe@kernel.dk>,
        Francis Moreau <francis.moro@gmail.com>,
        "Kent Overstreet" <kmo@daterainc.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] bcache changes for 3.17
Thread-Topic: [GIT PULL] bcache changes for 3.17
Thread-Index: AQHPyNsaw3KQXaSWGkK7y8L5KW1fI5vydQYAgAAWWgCAABHNgIAABlkA
Date: Fri, 5 Sep 2014 17:03:57 +0000
Message-ID: <F71A0899-EF6F-44A3-B207-E1DACC8721B6@cern.ch>
References: <20140805043346.GF541@moria.home.lan>
 <53E10D48.1010700@kernel.dk> <53E7251B.3080305@kieser.ca>
 <540966BA.9030106@gmail.com> <5409C5FC.6020406@kernel.dk>
 <5409D8BC.7030003@ehuk.net> <5409E7AB.7040704@kieser.ca>
In-Reply-To: <5409E7AB.7040704@kieser.ca>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [86.209.127.83]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_252E83ED-FB0F-4325-BEA9-5A5010D9C999";
	protocol="application/pkcs7-signature"; micalg=sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_252E83ED-FB0F-4325-BEA9-5A5010D9C999
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Sep 5, 2014, at 6:41 PM, Peter Kieser <peter@kieser.ca>
 wrote:

>=20
> On 2014-09-05 8:37 AM, Eddie Chapman wrote:
>> On 05/09/14 15:17, Jens Axboe wrote:
>>> (from oldest to newest). And that's just from 3.16 to 3.17-rc3, =
going
>>> all the way back to 3.10 would be a lot of work. If there's anyone =
that
>>> cares about bcache on stable kernels (and actually use it), now =
would be
>>> a good time to pipe up.
>>=20
>> Just "piping up" as I care about bcache and actually use it in =
production on 3.10! Shame I don't have the knowledge to try and backport =
these though :-)
>>=20
>> Eddie
>=20
> I'm "piping up" as well, I use bcache on 3.10 in production.
>=20
> -Peter
>=20


More "piping up": we currently use bcache on a few nodes in production, =
on 3.14 and 3.15, and plan to roll it out on a wider scale now.
If necessary we'll go with these kernels, but we'd certainly prefer our =
usual 3.10-based CentOS kernel.

Cheers,
 Arne

--
Arne Wiebalck
CERN IT=

--Apple-Mail=_252E83ED-FB0F-4325-BEA9-5A5010D9C999
Content-Disposition: attachment; filename="smime.p7s"
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIINuDCCBi4w
ggUWoAMCAQICCmEPqkwAAAAAAAMwDQYJKoZIhvcNAQEFBQAwQTESMBAGCgmSJomT8ixkARkWAmNo
MRQwEgYKCZImiZPyLGQBGRYEY2VybjEVMBMGA1UEAxMMQ0VSTiBSb290IENBMB4XDTA2MTAwMzA5
MzYxM1oXDTE2MTAwMzA5NDYxM1owWTESMBAGCgmSJomT8ixkARkWAmNoMRQwEgYKCZImiZPyLGQB
GRYEY2VybjEtMCsGA1UEAxMkQ0VSTiBUcnVzdGVkIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwdFGqthhWlgUOSZ6C6hReNEVGzbjf2IQgxo7
/rOfOQHZH3krQPQ37fqFroEr46PrruymZ/U+QAzmESZQ4Z+nCfBhm7cEi0TIhihHd4cEPaPxawGR
T9Ck7BBk9za8TUljF6c/JodnIcmIrpbazEbSAS1KEXwETHDsTrQ7lJ+6SzDP4/oOwrHrgJx+tKsm
gOsFSbBEK4OYx1UYQpYS9OJQk2Sc0q4a/SCSu+xbN8ppmgV3WFytN8NW20n3NpCCWYPzo9rXmPRA
7a/c6mf+RV5gPCnUqeW6KUvix5kz9+X8/4SQV/fU12OPdRvtkqcC+PpiePK7bjMLQJEYwvchJrSz
AwIDAQABo4IDDjCCAwowDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUmMyS0EYwNoyw7ZgNclGp
R0zdviEwCwYDVR0PBAQDAgGGMBAGCSsGAQQBgjcVAQQDAgECMCMGCSsGAQQBgjcVAgQWBBT/Rljl
vgfrVK8GmAaYe+TbiXbJ7DBRBgNVHSAESjBIMEYGCisGAQQBYAoCAQEwODA2BggrBgEFBQcCARYq
aHR0cDovL2NhLmNlcm4uY2gvY2EvY3JsL3BvbGljeS9jcC1jcHMucGRmMBkGCSsGAQQBgjcUAgQM
HgoAUwB1AGIAQwBBMB8GA1UdIwQYMBaAFJgK9+w+7FnWHa2ZvLUBPt7spudQMIH8BgNVHR8EgfQw
gfEwge6ggeuggeiGLWh0dHA6Ly9jYS5jZXJuLmNoL2NhL2NybC9DRVJOJTIwUm9vdCUyMENBLmNy
bIaBtmxkYXA6Ly8vQ049Q0VSTiUyMFJvb3QlMjBDQSxDTj1jZXJucm9vdGNhLENOPUNEUCxDTj1Q
dWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPWNl
cm4sREM9Y2g/Y2VydGlmaWNhdGVSZXZvY2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERp
c3RyaWJ1dGlvblBvaW50MIIBBAYIKwYBBQUHAQEEgfcwgfQwRAYIKwYBBQUHMAKGOGh0dHA6Ly9j
YS5jZXJuLmNoL2NhL2NybC9jZXJucm9vdGNhX0NFUk4lMjBSb290JTIwQ0EuY3J0MIGrBggrBgEF
BQcwAoaBnmxkYXA6Ly8vQ049Q0VSTiUyMFJvb3QlMjBDQSxDTj1BSUEsQ049UHVibGljJTIwS2V5
JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1jZXJuLERDPWNoP2NB
Q2VydGlmaWNhdGU/YmFzZT9vYmplY3RDbGFzcz1jZXJ0aWZpY2F0aW9uQXV0aG9yaXR5MA0GCSqG
SIb3DQEBBQUAA4IBAQAfEzvOeYohKndmJqnVdiCqZ38tSBxOOPsKUHW4UY1jBfYMXbnZ9keFQFlK
/g5X4aZPNBEHXw0eKpQVsMhEPWQrvx8T/f7GwtU+JNQhkgK9tnezmHxYzWgEC9MXZhfYzFSwMIF6
kSKllmUTnN35uF1EnT8+64daje+yEVcpmM34p8Fw125/WpKnRmwNp0YkUk6uMti6Y6vOTHttzIN5
P6elGoat8sadMqrVnaMNzG8hGUvSkYivYBs7msAPuwmXgLvIkXWPW+MDFs+x5Kzx75ZHv3c2WoKg
UxL5KZH9QqiR7t8P6YBfYW6SpzyGRi4QHN/iOLhXZ06R6aPljLEOn41JMIIHgjCCBmqgAwIBAgIK
G2rSugACAAJRYzANBgkqhkiG9w0BAQUFADBZMRIwEAYKCZImiZPyLGQBGRYCY2gxFDASBgoJkiaJ
k/IsZAEZFgRjZXJuMS0wKwYDVQQDEyRDRVJOIFRydXN0ZWQgQ2VydGlmaWNhdGlvbiBBdXRob3Jp
dHkwHhcNMTMxMDI3MTAyNjQyWhcNMTQxMDI3MTAyNjQyWjCBjjESMBAGCgmSJomT8ixkARkWAmNo
MRQwEgYKCZImiZPyLGQBGRYEY2VybjEWMBQGA1UECxMNT3JnYW5pYyBVbml0czEOMAwGA1UECxMF
VXNlcnMxETAPBgNVBAMTCHdpZWJhbGNrMQ8wDQYDVQQDEwY1NTg1MTAxFjAUBgNVBAMTDUFybmUg
V2llYmFsY2swggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCxYDn8A4EeRTjaXpd8IrE3
Z3r/Fch6OlueWx7+XOBmxjvwCOMYlLt7WQeowLORXz7aaVyofoZHqmZirNnOQgTpzs/6UQT6DrXr
bKFZUsoJ/07hsk4QQyxo2WxCMUpgAMMmx13L2erSb2sNwtYhS51Mz1hFFmjE3wiAqftJOEww9vHB
rjeR8tlH0ifD7oFgGIhfAsx9q79aW8YOAHIBUnyrK1W0pP9qp3+ZwuH6sUXyDvN9BjIiEIxeDcb+
9MtAiENXxWwNfpWGmOousEyRNwyjXCpaerDvYsgbeGo+WyckGWleGxVH6B7glokA71OuEzUxUTHz
pazGDDLxwaP36+bFAgMBAAGjggQUMIIEEDAdBgNVHQ4EFgQUMiRKoPIkk3aChfZ+QXzfNmTYkUYw
HwYDVR0jBBgwFoAUmMyS0EYwNoyw7ZgNclGpR0zdviEwggEyBgNVHR8EggEpMIIBJTCCASGgggEd
oIIBGYZHaHR0cDovL2NhLmNlcm4uY2gvY2EvY3JsL0NFUk4lMjBUcnVzdGVkJTIwQ2VydGlmaWNh
dGlvbiUyMEF1dGhvcml0eS5jcmyGgc1sZGFwOi8vL0NOPUNFUk4lMjBUcnVzdGVkJTIwQ2VydGlm
aWNhdGlvbiUyMEF1dGhvcml0eSxDTj1DRVJOUEtJLENOPUNEUCxDTj1QdWJsaWMlMjBLZXklMjBT
ZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPWNlcm4sREM9Y2g/Y2VydGlm
aWNhdGVSZXZvY2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERpc3RyaWJ1dGlvblBvaW50
MIIBLwYIKwYBBQUHAQEEggEhMIIBHTCBxQYIKwYBBQUHMAKGgbhsZGFwOi8vL0NOPUNFUk4lMjBU
cnVzdGVkJTIwQ2VydGlmaWNhdGlvbiUyMEF1dGhvcml0eSxDTj1BSUEsQ049UHVibGljJTIwS2V5
JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1jZXJuLERDPWNoP2NB
Q2VydGlmaWNhdGU/YmFzZT9vYmplY3RDbGFzcz1jZXJ0aWZpY2F0aW9uQXV0aG9yaXR5MFMGCCsG
AQUFBzAChkdodHRwOi8vY2EuY2Vybi5jaC9jYS9jcmwvQ0VSTiUyMFRydXN0ZWQlMjBDZXJ0aWZp
Y2F0aW9uJTIwQXV0aG9yaXR5LmNydDAOBgNVHQ8BAf8EBAMCBaAwPQYJKwYBBAGCNxUHBDAwLgYm
KwYBBAGCNxUIg73QCYLtjQ2G7Ysrgd71N4WA0GIehb+6A4TEzEwCAWQCAQowKQYDVR0lBCIwIAYI
KwYBBQUHAwIGCCsGAQUFBwMEBgorBgEEAYI3CgMEMCUGA1UdIAQeMBwwDAYKKwYBBAFgCgIBAjAM
BgoqhkiG90wFAgIBMDUGCSsGAQQBgjcVCgQoMCYwCgYIKwYBBQUHAwIwCgYIKwYBBQUHAwQwDAYK
KwYBBAGCNwoDBDBHBgNVHREEQDA+oCUGCisGAQQBgjcUAgOgFwwVYXJuZS53aWViYWxja0BjZXJu
LmNogRVBcm5lLldpZWJhbGNrQGNlcm4uY2gwRAYJKoZIhvcNAQkPBDcwNTAOBggqhkiG9w0DAgIC
AIAwDgYIKoZIhvcNAwQCAgCAMAcGBSsOAwIHMAoGCCqGSIb3DQMHMA0GCSqGSIb3DQEBBQUAA4IB
AQAp+9JprmqNFehFL9K03clXIOFOu6b74SXweYvfX6BEFYxGSxOuAR7Y3o4R/RXtqIBBHPVesYQv
O1n3QmByEN12zZMspsvyzVVZnXa0lxr8HGg9ALDLZAv5FGaDuivXe7K9ZNwBdDcXg5LygZNyoFHX
z4dyyAQr2N9k/3ll1nkJ+C4J38GZpUOiRmzfvS4I30//HFBMK6eKBh3urD+lJMKGDqhdrMLoMVCw
UFkT0Pj+swGhdR/dz/ANaXU433wws3nKGnWp4kea84QJtZCHYp+C87XYKYoZzs0BTxWEY29vhiw5
xCU2quiUWWNJZ7uWBjeqTOzyj0CfHtCrddsJjnOmMYIC4TCCAt0CAQEwZzBZMRIwEAYKCZImiZPy
LGQBGRYCY2gxFDASBgoJkiaJk/IsZAEZFgRjZXJuMS0wKwYDVQQDEyRDRVJOIFRydXN0ZWQgQ2Vy
dGlmaWNhdGlvbiBBdXRob3JpdHkCChtq0roAAgACUWMwCQYFKw4DAhoFAKCCAU8wGAYJKoZIhvcN
AQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwOTA1MTcwMzU4WjAjBgkqhkiG9w0B
CQQxFgQU0c9e3nvY9oTc3RR9fBSdTh/NCaswdgYJKwYBBAGCNxAEMWkwZzBZMRIwEAYKCZImiZPy
LGQBGRYCY2gxFDASBgoJkiaJk/IsZAEZFgRjZXJuMS0wKwYDVQQDEyRDRVJOIFRydXN0ZWQgQ2Vy
dGlmaWNhdGlvbiBBdXRob3JpdHkCChtq0roAAgACUWMweAYLKoZIhvcNAQkQAgsxaaBnMFkxEjAQ
BgoJkiaJk/IsZAEZFgJjaDEUMBIGCgmSJomT8ixkARkWBGNlcm4xLTArBgNVBAMTJENFUk4gVHJ1
c3RlZCBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eQIKG2rSugACAAJRYzANBgkqhkiG9w0BAQEFAASC
AQCwlzE/e0LMTb079EOkYX45MvPJNgh0hdmHIJ8eyt0rqJsz7bYnKDRpNbCqiXkkee1YSyPv9QcA
EA+pP8ZxPJsom7JN7HNBhUMeBrov5v+VAyxPVF93Rk/A4Bu1ByNGytJy7a26s0ndxH5tzVmv1Rw+
Kicnlr8QAyDW8XlGuScUOGIC5neRmE5ivVv7o8NV3yVXJNYsUOgGW92caJKsoIGayKtQZahEfg9b
WvZrcikeL36Qfa5rr6n49Hk8BDTBYMwZ0hu9zAlxrTbMzCzRd8Xr9H1HzATjZWHdKwXvEEFfchQR
7lHmi55jzV2zwiFl6akO+lVmhK8B1Py0gx/nqiaGAAAAAAAA

--Apple-Mail=_252E83ED-FB0F-4325-BEA9-5A5010D9C999--
