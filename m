Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbaKKMOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:14:23 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:59961 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbaKKMOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:14:19 -0500
Message-ID: <5461FD97.1080601@gmail.com>
Date: Tue, 11 Nov 2014 07:14:15 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@alien8.de>,
        Mark Salter <msalter@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH] rtc: Disable EFI rtc for x86
References: <1412339576-17972-1-git-send-email-matt@console-pimps.org>	<20141109182231.GA29337@pd.tnic>	<1415618533.14686.239.camel@mfleming-mobl1.ger.corp.intel.com>	<201411101723.49197@pali>	<5460EB92.1090501@gmail.com>	<20141110170417.GA17286@srcf.ucam.org>	<5461220E.20605@gmail.com>	<546126FF.3070600@zytor.com> <20141111113831.1119720e@alan.etchedpixels.co.uk>
In-Reply-To: <20141111113831.1119720e@alan.etchedpixels.co.uk>
x-hashcash: 1:21:141111:gnomes@lxorguk.ukuu.org.uk::1007f6bcef8bdeb57df7eab6d6b21d39:8e7d8047d9172fdf
x-hashcash: 1:21:141111:hpa@zytor.com::4d5ee847c8792c76c7c615a8d26b7e17:3bd1681b39729231
x-hashcash: 1:21:141111:mjg59@srcf.ucam.org::fcb2ad175107af145dcdf05d3324f7:f4a284b200f9bfe0
x-hashcash: 1:21:141111:pali.rohar@gmail.com::8db8461c484947a3bf3083e27e384ce2:ab14859ab0844fe9
x-hashcash: 1:21:141111:matt.fleming@intel.com::2d3dba4a0d609874725cfbf1c172761b:9f6fc2abcb4eea63
x-hashcash: 1:21:141111:bp@alien8.de::88a120bd828f28e296cd08c9ce122eae:f6a6b163c9e57272
x-hashcash: 1:21:141111:msalter@redhat.com::c619bc09956496976d0b694165067c8e:e6d18636860e9c31
x-hashcash: 1:21:141111:a.zummo@towertech.it::1ebcffcc3f4fba67d2493041fb18a4e9:120fc8f00094a542
x-hashcash: 1:21:141111:rtc-linux@googlegroups.com::57c3e1d8518d4beef05171575f529d03:9477d770bdc351f4
x-hashcash: 1:21:141111:linux-efi@vger.kernel.org::f96dc675cf410cd434c325824ede3b2c:9f4398e3458b5c32
x-hashcash: 1:21:141111:linux-kernel@vger.kernel.org::e014408de61b5b92304385729a968498:99a93c2366e9624d
x-hashcash: 1:21:141111:dyoung@redhat.com::30c99bfbea17db92123a08cdba7ee3d:4fd8578e9f90c924
x-stampprotocols: hashcash:1:17;mbound:0:10:3000:5000
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010608010602040409010701"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms010608010602040409010701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-11-11 06:38, One Thousand Gnomes wrote:
>>> look further into the options I have set in my kernel build, I may ha=
ve
>>> changed something else without remembering between booting with and
>>> without the CSM enabled.
>>>
>>
>> It could also be that the non-CSM BIOS somehow remaps the CMOS registe=
rs.
>
> I don't believe there is anything which prevents the CSM from faking a
> CMOS clock using SMM from whatever is actually in the hardware.
>
> Alan
>
It wouldn't surprise me if that were the case.  I've had some pretty=20
weird firmware related issues with other Lenovo systems before (like the =

brightness hot-keys causing the reported trip points for ACPI thermal=20
zones to temporarily change).

I've rebuilt the kernel I'm using with everything I can think of=20
possibly depending on the CSM compiled out or as modules, so I'll=20
hopefully have some more info soon.


--------------ms010608010602040409010701
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMTExMTIxNDE1
WjAjBgkqhkiG9w0BCQQxFgQU8GcXah9KBvgWLz/bgqwN3pBj7pMwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAAUXP0Ct5jLxEOJv9x0MrVRh7bzh/
bYzi6c5eckwuvZY0fxz+l+l19iHmAmFpGM1qQi+sHx0uxQNAZFqsV6A/1dcLRxyRUkw6bYk1
qrp3RJROVZtGOq92ynAp8OhUpdp01Wb2gypxG6bVNEB4KmlfvcwZrFFhSde5OR0jaIaLseWd
gopuxXC52TAuQA4KT+uwXhJWXcqwIsmykqz1fkG9TuAMAIZzouyfDssVZcyee51LnASO88xO
ois80X1dvYPx7jsOpBntwPTrkkqIQz1SsWwIfeSpBqLEcslNbtxOhMBVwSU42JtAysWoSZia
dwMSc3ho2iggU1HdnrOz8ZpMhgAAAAAAAA==
--------------ms010608010602040409010701--
