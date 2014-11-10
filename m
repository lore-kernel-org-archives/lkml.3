Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaKJUhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:37:46 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:65237 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaKJUho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:37:44 -0500
Message-ID: <5461220E.20605@gmail.com>
Date: Mon, 10 Nov 2014 15:37:34 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@alien8.de>,
        Mark Salter <msalter@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] rtc: Disable EFI rtc for x86
References: <1412339576-17972-1-git-send-email-matt@console-pimps.org> <20141109182231.GA29337@pd.tnic> <1415618533.14686.239.camel@mfleming-mobl1.ger.corp.intel.com> <201411101723.49197@pali> <5460EB92.1090501@gmail.com> <20141110170417.GA17286@srcf.ucam.org>
In-Reply-To: <20141110170417.GA17286@srcf.ucam.org>
x-hashcash: 1:21:141110:mjg59@srcf.ucam.org::94527a89c0d77f721e0ee88fbfa78c4b:bff6ef07150ce2a0
x-hashcash: 1:21:141110:pali.rohar@gmail.com::b0809378f145b36523a07a23b198161:9d849b9bd38474b
x-hashcash: 1:21:141110:matt.fleming@intel.com::b0e139ebc8cc08bd48aa6686661069d8:6a84dcdad41076e2
x-hashcash: 1:21:141110:bp@alien8.de::39c67ee621a2e696f9d3b31d336c5538:f4f286233cfcc924
x-hashcash: 1:21:141110:msalter@redhat.com::eabbf125afa40fd8e40b0deeaeed932b:1861c0987e666304
x-hashcash: 1:21:141110:a.zummo@towertech.it::3167283eeb5b41aba23ada63dc931fe2:2f1b76a24092566b
x-hashcash: 1:21:141110:rtc-linux@googlegroups.com::691667b8293c551576c550abe68d1d92:997ee8dae89b5bd3
x-hashcash: 1:21:141110:linux-efi@vger.kernel.org::bf1265e38965f63052356f772ba7c984:d12bb449d01521f1
x-hashcash: 1:21:141110:linux-kernel@vger.kernel.org::3221f035b388e914e5b23125188d1938:b836d7cf9ff51988
x-hashcash: 1:21:141110:dyoung@redhat.com::88f72d5a8fe81febab7e09beb2a0138f:7270a3958fe679e3
x-hashcash: 1:21:141110:hpa@zytor.com::e5998c1280c2a1559fba043be434ff83:28dba5ff031623e
x-stampprotocols: hashcash:1:17;mbound:0:10:3000:5000
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms050800080806010502030603"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms050800080806010502030603
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-11-10 12:04, Matthew Garrett wrote:
> On Mon, Nov 10, 2014 at 11:45:06AM -0500, Austin S Hemmelgarn wrote:
>
>> I agree, without it you need PC CMOS RTC support to access the RTC
>> on most systems, which in turn means that you have to enable the CSM
>> in the EFI firmware, which is annoying cause you can't easily dual
>> boot windows with secure boot when the CSM is enabled.
>
> CMOS RTC support doesn't depend on the CSM.
>
That's really interesting, because with it compiled in, I can't boot on=20
my EFI based thinkpad laptop without telling EFI to launch the CSM, and=20
with it compiled out, I can boot fine without the CSM.  I'll have to=20
look further into the options I have set in my kernel build, I may have=20
changed something else without remembering between booting with and=20
without the CSM enabled.


--------------ms050800080806010502030603
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFuDCC
BbQwggOcoAMCAQICAw9gVDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA4
MDgxMTMwNDRaFw0xNTAyMDQxMTMwNDRaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDdmm8R
BM5D6fGiB6rpogPZbLYu6CkU6834rcJepfmxKnLarYUYM593/VGygfaaHAyuc8qLaRA3u1M0
Qp29flqmhv1VDTBZ+zFu6JgHjTDniBii1KOZRo0qV3jC5NvaS8KUM67+eQBjm29LhBWVi3+e
a8jLxmogFXV0NGej+GHIr5zA9qKz2WJOEoGh0EfqZ2MQTmozcGI43/oqIYhRj8fRMkWXLUAF
WsLzPQMpK19hD8fqwlxQWhBV8gsGRG54K5pyaQsjne7m89SF5M8JkNJPH39tHEvfv2Vhf7EM
Y4WGyhLAULSlym1AI1uUHR1FfJaj3AChaEJZli/AdajYsqc7AgMBAAGjggFZMIIBVTAMBgNV
HRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNhdGUg
Zm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8E
BAMCA6gwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEE
AYI3CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8v
b2NzcC5jYWNlcnQub3JnMDEGA1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly9jcmwuY2FjZXJ0Lm9y
Zy9yZXZva2UuY3JsMDQGA1UdEQQtMCuBFGFoZmVycm9pbjdAZ21haWwuY29tgRNhaGVtbWVs
Z0BvaGlvZ3QuY29tMA0GCSqGSIb3DQEBDQUAA4ICAQCr4klxcZU/PDRBpUtlb+d6JXl2dfto
OUP/6g19dpx6Ekt2pV1eujpIj5whh5KlCSPUgtHZI7BcksLSczQbxNDvRu6LNKqGJGvcp99k
cWL1Z6BsgtvxWKkOmy1vB+2aPfDiQQiMCCLAqXwHiNDZhSkwmGsJ7KHMWgF/dRVDnsl6aOQZ
jAcBMpUZxzA/bv4nY2PylVdqJWp9N7x86TF9sda1zRZiyUwy83eFTDNzefYPtc4MLppcaD4g
Wt8U6T2ffQfCWVzDirhg4WmDH3MybDItjkSB2/+pgGOS4lgtEBMHzAGQqQ+5PojTHRyqu9Jc
O59oIGrTaOtKV9nDeDtzNaQZgygJItJi9GoAl68AmIHxpS1rZUNV6X8ydFrEweFdRTVWhUEL
70Cnx84YBojXv01LYBSZaq18K8cERPLaIrUD2go+2ffjdE9ejvYDhNBllY+ufvRizIjQA1uC
OdktVAN6auQob94kOOsWpoMSrzHHvOvVW/kbokmKzaLtcs9+nJoL+vPi2AyzbaoQASVZYOGW
pE3daA0F5FJfcPZKCwd5wdnmT3dU1IRUxa5vMmgjP20lkfP8tCPtvZv2mmI2Nw5SaXNY4gVu
WQrvkV2in+TnGqgEIwUrLVbx9G6PSYZZs07czhO+Q1iVuKdAwjL/AYK0Us9v50acIzbl5CWw
ZGj3wjGCA6EwggOdAgEBMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6
Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEh
MB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwCQYFKw4DAhoFAKCCAfUw
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMTEwMjAzNzM0
WjAjBgkqhkiG9w0BCQQxFgQUhwlNOp0hc8Gorm5JaZH5HzFtZjMwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAtH1Em6bE9dGNIksyLudnw4cj+XiA
9RFanMsaohTnT++6wSQUWm0mvuEPTBj8DjAq+v3hVC5OxFsOStpmPieFBn4JSGZUgFLw3r2U
fR2ZDjSRgAtMQmSsCt2zXnYIpZSEn3z+DERhEep8Jo6SlasoULmoqnsVWiHlcBwwCMgaXRKW
5SFSlgmE0sLZUl6THkTS6TamBJZl79Nqz2suzDZILFPF7FbMYTHkjCpJG+P4oWlAUhAgAChv
UE6AXm9ZPV43BvWoBqQaqpG+0zspnBJlBYK58mVYP989kpARPt9JBMxMWgjoaqaUO7+T3Xkd
DWwlBDftey8CJK+BX1yvaaVglAAAAAAAAA==
--------------ms050800080806010502030603--
