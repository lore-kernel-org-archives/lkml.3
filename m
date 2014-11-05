Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaKEUaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:30:35 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:38062 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaKEUac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:30:32 -0500
Message-ID: <545A88E6.2060509@gmail.com>
Date: Wed, 05 Nov 2014 15:30:30 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Martin Tournoij <martin@arp242.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] The SIGINFO signal from BSD
References: <1415200663.3247743.187387481.75CE9317@webmail.messagingengine.com> <545A7B00.1040309@gmail.com> <20141105201404.GH27083@thunk.org>
In-Reply-To: <20141105201404.GH27083@thunk.org>
x-hashcash: 1:21:141105:tytso@mit.edu::d464a142f8091fbbcf0aea9f54692208:8daed1c6a81c451e
x-hashcash: 1:21:141105:martin@arp242.net::bdacbe7799afadb0a071be913175c157:1dc43f57564c57cf
x-hashcash: 1:21:141105:linux-kernel@vger.kernel.org::1c7565d119b87a35a27e07ff056ba38b:b59afaa20a239693
x-stampprotocols: hashcash:1:17;mbound:0:10:3000:5000
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms060204040903040507050801"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms060204040903040507050801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-11-05 15:14, Theodore Ts'o wrote:
> On Wed, Nov 05, 2014 at 02:31:12PM -0500, Austin S Hemmelgarn wrote:
>>>
>>> SIGINFO prints the status of the process to the terminal; BSD cp, for=
 example,
>>> shows show much data it's copied:
>>>
>>>      $ cp large_file /dev/null
>>>      <press ^t>
>>>      load: 1.39  cmd: cp 85837 [running] 3.91r 0.00u 0.98s 8% 2340k
>>>      large_file -> /dev/null  15%
>>>
>>> As you see, it shows the current load, pid, process status, memory us=
age, as
>>> well as how much of the file has been copied. Many other BSD tools pr=
int similar
>>> statistics (mv, tar, dd, sleep, fetch, etc.).
>>
>> You have to understand however, that the reason that SIGINFO works lik=
e that
>> on *BSD is that the kernel and core userspace are developed together,
>> whereas on Linux, they are maintained entirely separately. Outside of =
core
>> userspace components, using SIGINFO that way on *BSD is just conventio=
n.
>
> Actually, the first line:
>
> 	load: 1.39  cmd: cp 85837 [running] 3.91r 0.00u 0.98s 8% 2340k
>
> is actually printed by the kernel.  It's actually something which is
> implemented in the BSD N_TTY line displine.  We never implemented it
> (at least when I was maintaining the tty subsystem) mostly out of
> laziness.  Part of the reason is that the main reason was that main
> reason why people (at least systems programmers / kernel programers
> like me) used ^T was to debug an apparently hung system, and for
> Linux, we had a much more powerful system using the magic-sysrq key.
>
I hadn't realized that it was actually the kernel printing that, but=20
then I've never really looked all that deep into the BSD source code.
Ironically, the magic-sysrq key is one of the big reasons I've=20
personally chosen to stay with Linux over any of the BSD derivatives. :)


--------------ms060204040903040507050801
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMTA1MjAzMDMw
WjAjBgkqhkiG9w0BCQQxFgQUYE+e3Hu1esBA62Ck5pRaT9zZIFcwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAwehs9/2KPIaaVnS4kyzYjaCgDiPq
n8/1TG9PhBESixcsu3lSSOuZQAXXTvUxk8vnNnk5rnN+ZBjCa9o39x6R+3kaMMr2jrmMWtDe
I7Z9oXxcAD9kv7D3FydU1TK4q79Lbmh4NNfhweEvrEDl7ILyVjLixUlNJIbkXTjd5aExf9oy
z6xqAkMI7dcIq2cgJ4K8n1+HeXTczdZQnAAcZYVR6jCUC2Pc0P3K72tsnn7J5MzJG6KK4tSt
448WOF0GZ1VnMowmTNWPMfe6N8DNgTZ2QYGIZGW3ASo1YhHg/NM2b0MUHUDQLb8UH6y8Hil5
zMIGaZ6VOJXfeSadctnUkYWJMgAAAAAAAA==
--------------ms060204040903040507050801--
