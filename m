Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbaG1LL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:11:26 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:41670 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751949AbaG1LLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:11:23 -0400
Message-ID: <53D62FC9.2010404@tu-dresden.de>
Date: Mon, 28 Jul 2014 13:11:05 +0200
From: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/2] perf tools: Default to python version 2
References: <53D135F9.1070104@tu-dresden.de> <1406258045-25726-1-git-send-email-namhyung@kernel.org> <1406258045-25726-2-git-send-email-namhyung@kernel.org> <53D22357.9010005@tu-dresden.de> <87wqb1ivnb.fsf@sejong.aot.lge.com> <53D242DC.9070503@tu-dresden.de> <87silmibxd.fsf@sejong.aot.lge.com>
In-Reply-To: <87silmibxd.fsf@sejong.aot.lge.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090102070405060405050601"
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms090102070405060405050601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Namhyung,

>>> I'm thinking about something like below.. but sadly it doesn't work f=
or
>>> me.. hmm.
>>
>> Actually this appears to work for me (with 2.6.9 & 2.7.6) and I =20
>> find this solution more
>> elegant.
>
> Thanks for testing.  It was my fault on setting symlink to a
> non-existing file for testing.  It now works well for me too.
>
> Can I add your Tested-by then?

Yes
Tested-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>

Plase note that your patch requires the previous patch that just set the =
default to python2.

I tested in an Arch Linux VM with:
A) no system install of python, source installation 2.6.9 in PATH
B) no system install of python, source installation 2.7.6 in PATH
C) python3 (as python) and python2 system installation

In all cases it reports to build with libpython and perf script with a du=
mmy Python script
works.

If no python whatsoever is in PATH it reports:

config/Makefile:121: The path 'python' is not executable.
sh: line 0: command: -c: invalid option
command: usage: command [-pVv] command [arg ...]
config/Makefile:122: The path '-config' is not executable.

And the created perf executable does not work with the dummy script.

If only pthon3 is in PATH I get the expected version error message (build=
 stops.)

Note that for the manual old installations of python I had an issue with =
linking order and
a -Werror issue that I resolved manually. But this is fixed with the late=
st system install
of python.

Best,
Thomas

>
> Thanks,
> Namhyung




--------------ms090102070405060405050601
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIPhTCC
BHQwggNcoAMCAQICCQCJkBEVWD6HmzANBgkqhkiG9w0BAQsFADBxMQswCQYDVQQGEwJERTEc
MBoGA1UEChMTRGV1dHNjaGUgVGVsZWtvbSBBRzEfMB0GA1UECxMWVC1UZWxlU2VjIFRydXN0
IENlbnRlcjEjMCEGA1UEAxMaRGV1dHNjaGUgVGVsZWtvbSBSb290IENBIDIwHhcNMTQwMjEx
MTMxMTQ1WhcNMTkwNzA5MjM1OTAwWjBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZl
cmVpbjEQMA4GA1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFs
IC0gRzAxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6ZvDZ4X5Da71jVTDllA1
PWLpbkztlNcAW5UidNQg6zSP1uzAMQQLmYHiphTSUqAoI4SLdIkEXlvg4njBeMsWyyg1OXst
kEXQ7aAAeny/Sg4bAMOG6VwrMRF7DPOCJEOMHDiLamgAmu7cT3ir0sYTm3at7t4m6O8Br3QP
wQmi9mvOvdPNFDBP9eXjpMhim4IaAycwDQJlYE3t0QkjKpY1WCfTdsZxtpAdxO3/NYZ9bzOz
2w/FEcKKg6GUXUFr2NIQ9Uz9ylGs2b3vkoO72uuLFlZWQ8/h1RM9ph8nMM1JVNvJEzSacXXF
bOqnC5j5IZ0nrz6jOTlIaoytyZn7wxLyvQIDAQABo4IBJDCCASAwDgYDVR0PAQH/BAQDAgEG
MB0GA1UdDgQWBBRJt8bP6D0ff+pEexMp9/EKcD7eZDAfBgNVHSMEGDAWgBQxw3kbuvVT1xfg
iXotF2wKsyudMzASBgNVHRMBAf8ECDAGAQH/AgECMD8GA1UdHwQ4MDYwNKAyoDCGLmh0dHA6
Ly9vY3NwMDMzNi50ZWxlc2VjLmRlL3JsL0RUX1JPT1RfQ0FfMi5jcmwweQYIKwYBBQUHAQEE
bTBrMCwGCCsGAQUFBzABhiBodHRwOi8vb2NzcDAzMzYudGVsZXNlYy5kZS9vY3NwcjA7Bggr
BgEFBQcwAoYvaHR0cDovL29jc3AwMzM2LnRlbGVzZWMuZGUvY3J0L0RUX1JPT1RfQ0FfMi5j
ZXIwDQYJKoZIhvcNAQELBQADggEBACwvqeBeQy8FcNxRlXVdgI47DMFjWFSBMIOcXalRh8m2
1w8runhIJGBCzPGi4jPhMh4ym1ETlXnGtazQJO0YFLwvKuovq7ITrEkdXgALBBhqmmXU6Ec1
vK7t33S22PGAUGWgxtojm41TR8psu0DJlV1OYHor5LtmQFWvtjPB6iMhbvxUnd0zQm5Ma9Xk
w/LqBrdaMmoyRXS2tW/+6v8cY6q7iNH4WK8gfo+///b3OHeLGrZQP609R3lGw1e0F2KHvZ6j
NiUHaCSqIvL2rynsN6UUma66AWCGdS1hFbp4loe1ks/hUJGeWToV7J5axob8KD5mutTZNa+t
PEkihYfub48wggVhMIIESaADAgECAgcXpCR5aFyOMA0GCSqGSIb3DQEBCwUAMFoxCzAJBgNV
BAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAwDgYDVQQLEwdERk4tUEtJMSQwIgYDVQQD
ExtERk4tVmVyZWluIFBDQSBHbG9iYWwgLSBHMDEwHhcNMTQwNTI3MTQ1MzI5WhcNMTkwNzA5
MjM1OTAwWjCBhTELMAkGA1UEBhMCREUxKDAmBgNVBAoTH1RlY2huaXNjaGUgVW5pdmVyc2l0
YWV0IERyZXNkZW4xDDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMTVFUgRHJlc2RlbiBDQSAtIEcw
MjEgMB4GCSqGSIb3DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQDBDh6T80T27NAn91B6YQsENBWT/LEfbGPagOzhM1w1Cjx3ICCilYCg
JeIPQmBZT9RalxxF2z2OGDPcRTuqcaFPkgtdGaw1BFEIX+kGe3Itz2GlaKLPnQBHwcp+ODj8
OdgvD4wZqYkvsjaDx1ck2spHHVxLEh/7ybexJL3f1zatqPJkK2fJuOeeUz3Ip74sPqhKn3QA
5Q5E4JUHlvh3l4TDFrbmEIMntRqrJ+LaG2JCQ2G9hfEUvxeo3Zr6y88IdG+d7Hbp+XJkZYoO
enVItm9z+atzo+NBxdmW8nD00xJAG52xQSwN4HR+qtj0CcnMtj41zXv6ul2E7ltRubqNM3sn
AgMBAAGjggH+MIIB+jASBgNVHRMBAf8ECDAGAQH/AgEBMA4GA1UdDwEB/wQEAwIBBjARBgNV
HSAECjAIMAYGBFUdIAAwHQYDVR0OBBYEFMUrU5MXg8n1RkLtQ2rftoCmR/LgMB8GA1UdIwQY
MBaAFEm3xs/oPR9/6kR7Eyn38QpwPt5kMBwGA1UdEQQVMBOBEXBraUB0dS1kcmVzZGVuLmRl
MIGIBgNVHR8EgYAwfjA9oDugOYY3aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9v
dC1jYS9wdWIvY3JsL2NhY3JsLmNybDA9oDugOYY3aHR0cDovL2NkcDIucGNhLmRmbi5kZS9n
bG9iYWwtcm9vdC1jYS9wdWIvY3JsL2NhY3JsLmNybDCB1wYIKwYBBQUHAQEEgcowgccwMwYI
KwYBBQUHMAGGJ2h0dHA6Ly9vY3NwLnBjYS5kZm4uZGUvT0NTUC1TZXJ2ZXIvT0NTUDBHBggr
BgEFBQcwAoY7aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1jYS9wdWIvY2Fj
ZXJ0L2NhY2VydC5jcnQwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ2xv
YmFsLXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQCJ
hMBD4Oh4PXhRwECrWgomDDnELDDFh4FN1e2g0gYbKLg/kA0gw6RKImh4GhTRAbENxW2My+tH
aKFjtwQdBaanilk4DN581jqxjo37jPEwDmNNzT8U4ssiwmkMD2bWM2vTcc7lDj2g7w+sRzIJ
8zi1AtCV43bJT8xBVj0PQpFuqYVvYzgMq+KNtGn4YyiBAMyDY1EzPEgtOovN7sqXb3jGDa71
gqdHWIKf9orfDWCZ/Y8d+Y+rSqtBAHj0fnAzjnIgtJvUIif+Afx/4Rvxy0MHj3q6uHhPFcZ9
QBPm+vxX2nWXEMlJcf1A/Igdah5hUpkmAQIUUJso8QbE4gXBS/BPMIIFpDCCBIygAwIBAgIH
FyxZ1i7USDANBgkqhkiG9w0BAQUFADCBhTELMAkGA1UEBhMCREUxKDAmBgNVBAoTH1RlY2hu
aXNjaGUgVW5pdmVyc2l0YWV0IERyZXNkZW4xDDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMTVFUg
RHJlc2RlbiBDQSAtIEcwMjEgMB4GCSqGSIb3DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUwHhcN
MTQwMjI1MTgwOTExWhcNMTcwMjI0MTgwOTExWjBdMQswCQYDVQQGEwJERTEoMCYGA1UEChMf
VGVjaG5pc2NoZSBVbml2ZXJzaXRhZXQgRHJlc2RlbjEMMAoGA1UECxMDWklIMRYwFAYDVQQD
Ew1UaG9tYXMgSWxzY2hlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzxoc9lcS
97ONeAVS1Y361WCBX3sCjHlopnPOgLGsscTI3jd75BxiAeSCvFwu9POGs2vsIHeiKKQyu+3F
s3QHKbewYH/E9D5dcJ8VtKFBL0jU7NaXm8jLY/0nPOOX1t8OGdykV1Hio7KH5RyyOX/XZ6cs
DNRFNACcOMyMTHuSIcMX4htxPmiLsNBXTQ0Ohf/7WClIRIXxYO0EMMA/4Fb3WC23YdPSedJr
RRU/cs0nKcV4g6O14ZfvzN3hQFqs06TBhde3Mv+yUyKHalaOoggNlBqjRXh6KyCYDZnou6Bm
S1EQs+UchWU6jo8WXaKbadJpaIxL3HtcV5JFHZOibtmzJQIDAQABo4ICPjCCAjowLwYDVR0g
BCgwJjARBg8rBgEEAYGtIYIsAQEEAwEwEQYPKwYBBAGBrSGCLAIBBAMBMAkGA1UdEwQCMAAw
CwYDVR0PBAQDAgXgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQU
tl3TKO1q/IByitqlWh99jrj7AagwHwYDVR0jBBgwFoAUxStTkxeDyfVGQu1Dat+2gKZH8uAw
JgYDVR0RBB8wHYEbdGhvbWFzLmlsc2NoZUB0dS1kcmVzZGVuLmRlMIGLBgNVHR8EgYMwgYAw
PqA8oDqGOGh0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvdHUtZHJlc2Rlbi1jYS9wdWIvY3JsL2df
Y2FjcmwuY3JsMD6gPKA6hjhodHRwOi8vY2RwMi5wY2EuZGZuLmRlL3R1LWRyZXNkZW4tY2Ev
cHViL2NybC9nX2NhY3JsLmNybDCB2QYIKwYBBQUHAQEEgcwwgckwMwYIKwYBBQUHMAGGJ2h0
dHA6Ly9vY3NwLnBjYS5kZm4uZGUvT0NTUC1TZXJ2ZXIvT0NTUDBIBggrBgEFBQcwAoY8aHR0
cDovL2NkcDEucGNhLmRmbi5kZS90dS1kcmVzZGVuLWNhL3B1Yi9jYWNlcnQvZ19jYWNlcnQu
Y3J0MEgGCCsGAQUFBzAChjxodHRwOi8vY2RwMi5wY2EuZGZuLmRlL3R1LWRyZXNkZW4tY2Ev
cHViL2NhY2VydC9nX2NhY2VydC5jcnQwDQYJKoZIhvcNAQEFBQADggEBADkeZ80dWsjpjOkn
/Rk/1nBWHj139rRsPNCrwr2CZLHLiO9pB6SYTx9W5/7v5hg8883E9ProF/h+nhKiaLtNxsBw
jx8a1v8Uz4buJSeYsFs0wEl3sOoCsfwVNjgJ++AcYu8zsOaalIzeBc4dOiP7gMyN6vyODX3H
HJSySzuffl+ywGQCJWcsjNrOnrRYw99vmKcLB9aI728AMNr/ugJcIGcEfu6ABtECHDhsgYKS
iS+KElT7Yqak4Up7Ji+Q03l4r0s6e9NjT+nScN5ap8g30j0PRWdsQ/fxpM5cwP8nP3if7i5p
3Qy5GEnIEusfkLFckPVLJhRYtL1+kJOVsUs+S4gxggPUMIID0AIBATCBkTCBhTELMAkGA1UE
BhMCREUxKDAmBgNVBAoTH1RlY2huaXNjaGUgVW5pdmVyc2l0YWV0IERyZXNkZW4xDDAKBgNV
BAsTA1pJSDEcMBoGA1UEAxMTVFUgRHJlc2RlbiBDQSAtIEcwMjEgMB4GCSqGSIb3DQEJARYR
cGtpQHR1LWRyZXNkZW4uZGUCBxcsWdYu1EgwCQYFKw4DAhoFAKCCAhcwGAYJKoZIhvcNAQkD
MQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwNzI4MTExMTA1WjAjBgkqhkiG9w0B
CQQxFgQUju27Hb6nF6wBNOWcbFFypvY3wKkwbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQME
ASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0D
AgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBogYJKwYBBAGCNxAEMYGUMIGRMIGFMQsw
CQYDVQQGEwJERTEoMCYGA1UEChMfVGVjaG5pc2NoZSBVbml2ZXJzaXRhZXQgRHJlc2RlbjEM
MAoGA1UECxMDWklIMRwwGgYDVQQDExNUVSBEcmVzZGVuIENBIC0gRzAyMSAwHgYJKoZIhvcN
AQkBFhFwa2lAdHUtZHJlc2Rlbi5kZQIHFyxZ1i7USDCBpAYLKoZIhvcNAQkQAgsxgZSggZEw
gYUxCzAJBgNVBAYTAkRFMSgwJgYDVQQKEx9UZWNobmlzY2hlIFVuaXZlcnNpdGFldCBEcmVz
ZGVuMQwwCgYDVQQLEwNaSUgxHDAaBgNVBAMTE1RVIERyZXNkZW4gQ0EgLSBHMDIxIDAeBgkq
hkiG9w0BCQEWEXBraUB0dS1kcmVzZGVuLmRlAgcXLFnWLtRIMA0GCSqGSIb3DQEBAQUABIIB
ALDW3uHCmsT1nZ3t2s9mmHv3W0L9TUVMEaIILFX3SSfRn2gTX8NljNIXqwCcYXWuTXz5ENjs
1uRJMshwp7XdiOFG4nS1x/k8VzlYUzDwnIRm0L3Y1fS5Op8nclyPODfWXcAmzCXhYuZdQCzO
5vZb1lKh9xe7p8iYp3hK6TJlBWYt+Vv9or14ZP5PLtSHNFrI6AdCQBDsSPHBRaHT5Aa3O5Eh
NpMYmqH6Ud6sH7GGnrlL7dLSJRm/AY9HttdWXQ0KkMZ4uon9XHVj07eDL/KgCMlJB2mRnzv0
SBx4DJa+X5I5wx/0GKkC6uissUoaWTlrQC/B+mjqEFSWSfdMVjqDOOwAAAAAAAA=
--------------ms090102070405060405050601--
