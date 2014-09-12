Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaILJlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:41:09 -0400
Received: from mail.pawisda.de ([213.157.4.156]:49295 "EHLO
	mailrelay.pawisda.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaILJlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:41:07 -0400
Message-ID: <5412BFAF.7050900@lsexperts.de>
Date: Fri, 12 Sep 2014 11:41:03 +0200
From: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
CC: Conrad Kostecki <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: AW: AW: AW: [PATCH] x86: HPET force enable for Soekris net6501
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5683.6030708@zytor.com> <aedabafbb1f0433c9d67ee998971150c@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5BB6.9070405@zytor.com> <1051d374173243b2828efcd21f60ac36@DB4PR04MB265.e <0363648bf9644167bf5aa0a954cd145b@DB4PR04MB265.eurprd04.prod.outlook.com> <540F06F1.1040608@lsexperts.de> <alpine.DEB.2.10.1409091649510.11037@nanos> <540F1C43.2080708@zytor.com>
In-Reply-To: <540F1C43.2080708@zytor.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms060604080601000801080503"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms060604080601000801080503
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

hi,

On 09/09/2014 05:26 PM, H. Peter Anvin wrote:
> On 09/09/2014 07:54 AM, Thomas Gleixner wrote:
>>
>> @hpa: You asked whether this might affect any other e6xx devices.
>>
>> According to the atom e6xx-series datasheet the HPET is non optional
>> and always memory mapped to 0xfed00000. I don't see how that would
>> harm any machine which has the hpet proper advertised via ACPI.
>>
>=20
> That seems straightforward then.

this means the original patch written by Conrad is going to be applied?
Is there anything we can do to help regarding this issue?

> I still wish someone would take a cluebat to Soekris.  We keep hearing
> crap like this about their firmware over and over and over again.  It
> isn't like you can't get EDK2 or Coreboot and build a BIOS based mostly=

> on Open Source components these days... oh, wait.

I have send them another message regarding this issue, but so far
they did not respond. In the past their responsiveness also varied a lot
according to my collegue.


Regards, Eric

--=20
LSE Leading Security Experts GmbH, Postfach 100121, 64201 Darmstadt
Unternehmenssitz: Weiterstadt, Amtsgericht Darmstadt: HRB8649
Gesch=E4ftsf=FChrer: Oliver Michel, Sven Walther


--------------ms060604080601000801080503
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIILVDCC
BRowggQCoAMCAQICEG0Z6qcZT2ozIuYiMnqqcd4wDQYJKoZIhvcNAQEFBQAwga4xCzAJBgNV
BAYTAlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMOU2FsdCBMYWtlIENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEhMB8GA1UECxMYaHR0cDovL3d3dy51c2VydHJ1c3Qu
Y29tMTYwNAYDVQQDEy1VVE4tVVNFUkZpcnN0LUNsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQg
RW1haWwwHhcNMTEwNDI4MDAwMDAwWhcNMjAwNTMwMTA0ODM4WjCBkzELMAkGA1UEBhMCR0Ix
GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UE
ChMRQ09NT0RPIENBIExpbWl0ZWQxOTA3BgNVBAMTMENPTU9ETyBDbGllbnQgQXV0aGVudGlj
YXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAJKEhFtLV5jUXi+LpOFAyKNTWF9mZfEyTvefMn1V0HhMVbdClOD5J3EHxcZppLkyxPFA
GpDMJ1Zifxe1cWmu5SAb5MtjXmDKokH2auGj/7jfH0htZUOMKi4rYzh337EXrMLaggLW1DJq
1GdvIBOPXDX65VSAr9hxCh03CgJQU2yVHakQFLSZlVkSMf8JotJM3FLb3uJAAVtIaN3FSrTg
7SQfOq9xXwfjrL8UO7AlcWg99A/WF1hGFYE8aIuLgw9teiFX5jSw2zJ+40rhpVJyZCaRTqWS
D//gsWD9Gm9oUZljjRqLpcxCm5t9ImPTqaD8zp6Q30QZ9FxbNboW86eb/8ECAwEAAaOCAUsw
ggFHMB8GA1UdIwQYMBaAFImCZ33EnSZwAEu0UEh83j2uBG59MB0GA1UdDgQWBBR6E04AdFvG
eGNkJ8Ev4qBbvHnFezAOBgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIBADARBgNV
HSAECjAIMAYGBFUdIAAwWAYDVR0fBFEwTzBNoEugSYZHaHR0cDovL2NybC51c2VydHJ1c3Qu
Y29tL1VUTi1VU0VSRmlyc3QtQ2xpZW50QXV0aGVudGljYXRpb25hbmRFbWFpbC5jcmwwdAYI
KwYBBQUHAQEEaDBmMD0GCCsGAQUFBzAChjFodHRwOi8vY3J0LnVzZXJ0cnVzdC5jb20vVVRO
QWRkVHJ1c3RDbGllbnRfQ0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1
c3QuY29tMA0GCSqGSIb3DQEBBQUAA4IBAQCF1r54V1VtM39EUv5C1QaoAQOAivsNsv1Kv/av
QUn1G1rF0q0bc24+6SZ85kyYwTAo38v7QjyhJT4KddbQPTmGZtGhm7VNm2+vKGwdr+XqdFqo
2rHA8XV6L566k3nK/uKRHlZ0sviN0+BDchvtj/1gOSBH+4uvOmVIPJg9pSW/ve9g4EnlFsjr
P0OD8ODuDcHTzTNfm9C9YGqzO/761Mk6PB/tm/+bSTO+Qik5g+4zaS6CnUVNqGnagBsePdIa
XXxHmaWbCG0SmYbWXVcHG6cwvktJRLiQfsrReTjrtDP6oDpdJlieYVUYtCHVmdXgQ0BCML7q
peeU0rD+83X5f27nMIIGMjCCBRqgAwIBAgIQGkNFbXur7DgrRwBLStr+YDANBgkqhkiG9w0B
AQUFADCBkzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
A1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxOTA3BgNVBAMTMENP
TU9ETyBDbGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTAeFw0xMzEx
MTgwMDAwMDBaFw0xNDExMTgyMzU5NTlaMIIBOjELMAkGA1UEBhMCREUxDjAMBgNVBBETBTY0
MzMxMQswCQYDVQQIEwJIRTEUMBIGA1UEBxMLV2VpdGVyc3RhZHQxGzAZBgNVBAkTElJvYmVy
dC1Lb2NoLVN0ci4gOTEqMCgGA1UEChMhTFNFIExlYWRpbmcgU2VjdXJpdHkgRXhwZXJ0cyBH
bWJIMUcwRQYDVQQLEz5Jc3N1ZWQgdGhyb3VnaCBMU0UgTGVhZGluZyBTZWN1cml0eSBFeHBl
cnRzIEdtYkggRS1QS0kgTWFuYWdlcjEfMB0GA1UECxMWQ29ycG9yYXRlIFNlY3VyZSBFbWFp
bDEYMBYGA1UEAxMPRXJpYyBTZXN0ZXJoZW5uMSswKQYJKoZIhvcNAQkBFhxlcmljLnNlc3Rl
cmhlbm5AbHNleHBlcnRzLmRlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnRUK
+zJFuS+lh6Lhbcqy9HVpx+Ch4W8z0O7Fy97FxCG5eEzDLSiD8qDd0V5osgIvvOGrrJjmIMfU
h8GsKziApG4EMMzpY/0l2ZCm4rQ+RXrXsQivlNa17MuRqrcVgn2PeJyGkWdwyN2X8CK2K/xX
DRpcxUSygr5N4omoQ3b8d/kqsfyvmd6cdqZa/JgPbLEbJM9VqrKKVYjcRp/HcxWKxfd61upG
LJuWSiQK95xDeGhTGshVa7xzW5nPYuv5TkFtYE8szaw7cnOYz9jVZTEFd3EZDT+lr9BQd66C
VaV9MnEne9rdSpyF4OQeLDkryll9+eyaeFv2KO9Gf9orFJg3MwIDAQABo4IB1jCCAdIwHwYD
VR0jBBgwFoAUehNOAHRbxnhjZCfBL+KgW7x5xXswHQYDVR0OBBYEFN9d8zR95tncPrxEvBPE
8mBdYjUHMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUF
BwMEBggrBgEFBQcDAjBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDBTArMCkGCCsGAQUFBwIB
Fh1odHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBXBgNVHR8EUDBOMEygSqBIhkZodHRw
Oi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9DbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3Vy
ZUVtYWlsQ0EuY3JsMIGIBggrBgEFBQcBAQR8MHowUgYIKwYBBQUHMAKGRmh0dHA6Ly9jcnQu
Y29tb2RvY2EuY29tL0NPTU9ET0NsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxD
QS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAnBgNVHREEIDAe
gRxlcmljLnNlc3Rlcmhlbm5AbHNleHBlcnRzLmRlMA0GCSqGSIb3DQEBBQUAA4IBAQAciB3s
tus9avAb1TDylaCrwm0U4dwbUsoWDjj9qvycnZ/05E4JjAxL/OEI3tqIB5WUD9tJtM2g/sz8
p71vv3u4oAemxBSIPkTsSm/i21kczTeDUcPKD3bOk5+DNh3t3dKsTymyQHeXYsOlC4A4dQby
lNmxOXs1rIzGGnmUit9LwSJo1br5/Wb3zVk8EszhXl0clqRDxLaHhhyLV0dmn/fK+fLEyoEo
GFzDj0vEGeKeF2ZRyufZ++e7CpUByybjDaub6SSgRm5UIVJDnGUv/H4DoXMh61UFSZY4qpxu
S+LTlXumXWRqgPwLfJ9ot9XEMkG1KwXgKJPRopafjZ38glHzMYIEGTCCBBUCAQEwgagwgZMx
CzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1Nh
bGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMTkwNwYDVQQDEzBDT01PRE8gQ2xp
ZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEBpDRW17q+w4K0cAS0ra
/mAwCQYFKw4DAhoFAKCCAkUwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMTQwOTEyMDk0MTAzWjAjBgkqhkiG9w0BCQQxFgQUql3AIbuT5rPEYkhuOBrrwvSj
UVkwbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0D
AgIBKDCBuQYJKwYBBAGCNxAEMYGrMIGoMIGTMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3Jl
YXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8gQ0Eg
TGltaXRlZDE5MDcGA1UEAxMwQ09NT0RPIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2Vj
dXJlIEVtYWlsIENBAhAaQ0Vte6vsOCtHAEtK2v5gMIG7BgsqhkiG9w0BCRACCzGBq6CBqDCB
kzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMH
U2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxOTA3BgNVBAMTMENPTU9ETyBD
bGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIQGkNFbXur7DgrRwBL
Str+YDANBgkqhkiG9w0BAQEFAASCAQBUCgK4YRsF4wDOBLmAX02DoYsZ8C66B7O4aSP6PSF3
s+h049ERGPLbi+HxzXQ8qC5nBPuBduAhvWW9d2w9hZE4mwGjWQA42CvTUuNEu8sshgBT5/+d
13nvOPB0+DlIwAvAz2b0kK15k15xFbOeAA8kuW5nGc1HrXp07XGEAKoBs+ORF80qDpMeOQTW
rgOqtAdgKi0Klk1nY2qV+RqCmdwGW8e41/HpqxilbDSccpBlHJJl3cYbJ/zfnbgjEPS86UNz
LsXMzuI9fY9I2/ECYaERQEyY6edQvNkKzXwfEnXD0xKErkVDBKmTKzmePnCVOUKVv58Snajh
kKpptC2GfnMCAAAAAAAA
--------------ms060604080601000801080503--
