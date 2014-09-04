Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbaIDR6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:58:48 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:38465 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbaIDR6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:58:46 -0400
Message-ID: <5408A84C.1090806@gmail.com>
Date: Thu, 04 Sep 2014 13:58:36 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>,
        Peter Zijlstra <peterz@infradead.org>
CC: Borislav Petkov <bp@alien8.de>,
        =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christopher Barry <christopher.r.barry@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: OT: Open letter to the Linux World
References: <20140812153812.2923046a@monolith.infinux.org> <20140812202129.GA20344@home.goodmis.org> <yw1xr40l2whi.fsf@unicorn.mansr.com> <20140813082756.GB2923@twins.programming.kicks-ass.net> <20140813090013.GA20581@pd.tnic> <53F242D1.4050506@ahsoftware.de> <20140904075453.GK3190@worktop.ger.corp.intel.com> <54083C0F.1040807@ahsoftware.de> <540878D4.7080501@gmail.com> <5408A175.3090400@ahsoftware.de>
In-Reply-To: <5408A175.3090400@ahsoftware.de>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080904080504010903050304"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms080904080504010903050304
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 2014-09-04 13:29, Alexander Holler wrote:
> Am 04.09.2014 16:36, schrieb Austin S Hemmelgarn:
>> On 2014-09-04 06:16, Alexander Holler wrote:
>>>
>>> It's a myth that C++ ends up in bigger code than C. At least in my
>>> experience. Especially when the latest additions to C++ are in effect=

>>> (like the move-semantics in C++11 I like quiet a lot and which you ge=
t
>>> almost for free (by changing nothing) when you use the STL). Thread
>>> support is now also standardized (in C++11), quiet nice to use.
>=20
>> Assuming you are writing in a standalone environment (no standard
>> libraries), then yes, your code will usually be about the same size
>> (unless you go way overboard with the object-oriented stuff); but the
>> runtime is larger in almost all non-standalone environments, and there=

>> are some cases that code does end up larger in C++.  A lot of 'Clean C=
'
>> (stuff written so that it compiles correctly as C, C++ and Objective C=
)
>> that I have seen seems to end up larger (by about 4-6%) when built as
>> C++ (although it usually does much worse as Objective C).
>=20
> There are always corner cases and I never would use some "Clean C" code=

> to compare sizes of C and C++. There is a whole lot of stuff you just
> can't, shouldn't or wouldn't do when using C instead of C++.
>=20
> And just throwing in some numbers without any explanation about feature=
s
> (like exceptions), optimizations and so on you've enabled for the tests=

> you used to get those numbers, doesn't work. ;)
>=20
> I can't really comment on what you mean with "standalone environment" o=
r
> "non-standalone environment", as I don't know what you mean with that.
> But if several programms share e.g. the stuff which is in libstdc++.
> you'll get a lot of size back when compared with C-only programms where=

> everyone invents the wheel again and again.
By standalone environment, I mean no libraries, no libc[++], no external
dependencies, and in the case of a lot of kernel programming, no
built-ins.  A OS kernel HAS to be written like that, and it's easier to
do that in C than C++.  I doubt that you have ever looked at any source
code for Windows drivers, but Windows is written in C++, and they still
are just as mind-numbingly insane as some of the poorly maintained,
vendor originated Linux drivers.
Not all C is like the Linux kernel, and in fact, if you use Linux,
probably more than half of your user-space programs were written in C.
They use dynamic linking just like C++ programs (but often with less
complex symbol mangling).


--------------ms080904080504010903050304
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwOTA0MTc1ODM2
WjAjBgkqhkiG9w0BCQQxFgQU2EhyfmF7HnEZm/KvVbxBjGUrm5kwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAezEyp5UiR0UwajoqYJ3G5RPksoe4
NVn+UDEABUW9IQi/7H8mEcAzKquNgppQjTRRZfV1MepKttnASRYwO/xcoo8A71bUaCq7Q9a2
/a6KprO/st4ZrYuga3LfPNrl+VYjYTYpRPiQUC4ENkuPuH4n4d2yJihemP0ilwxBMuHd/vLT
9cYbUb7MUNVM6Y0tVg4saEzzLANgEmjrABtqWsienJ3owSAxaDqQsy9dmEQKKOO6XQqP+eOS
4vK2ZtW9GOi3cLF4tVi6pjK2QK669RiSJX7eGdQuoZwqmP+OlqfKYFzWgmEx62/RblL2VWqF
1RWqDra6lbEAIrPi2cFgr8QPHAAAAAAAAA==
--------------ms080904080504010903050304--
