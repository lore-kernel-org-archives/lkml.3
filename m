Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbbAVOtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:49:18 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:49329 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbbAVOtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:49:15 -0500
Message-ID: <54C10DDC.9000503@gmail.com>
Date: Thu, 22 Jan 2015 09:49:00 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
CC: Daniel Mack <daniel@zonque.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux API <linux-api@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Djalal Harouni <tixxdz@opendz.org>, Johannes Stezenbach <js@sig21.net>,
        "Theodore T'so" <tytso@mit.edu>
Subject: Re: [PATCH 01/13] kdbus: add documentation
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>	<1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>	<54BE5DC8.70706@gmail.com>	<54BE9D08.7010804@zonque.org>	<54BF805B.4000609@gmail.com>	<54BFDAAA.50203@zonque.org>	<54C0CE8A.5080805@gmail.com> <CANq1E4S=3qNw599L85uj-8aXwxeV+mcurB_Nu_rHH8opAeePjw@mail.gmail.com>
In-Reply-To: <CANq1E4S=3qNw599L85uj-8aXwxeV+mcurB_Nu_rHH8opAeePjw@mail.gmail.com>
x-hashcash: 1:21:150122:dh.herrmann@gmail.com::ab082621598e099797083ac78ebaa3a:f8a9a8104c4b5eeb
x-hashcash: 1:21:150122:mtk.manpages@gmail.com::673f3f44b6dad75ead7def1b1578e02b:f5d5125d20dbbdfc
x-hashcash: 1:21:150122:daniel@zonque.org::d4df2625554ea36d8a5bccb78f96115f:f9b0f47c8d5d77c5
x-hashcash: 1:21:150122:gregkh@linuxfoundation.org::9ffd673ce6e2cf6dd5edea4ef1cfc947:d5435a6a3ce65173
x-hashcash: 1:21:150122:arnd@arndb.de::529e872e5d86500c29c519366bebd262:9fcd4db177ec068b
x-hashcash: 1:21:150122:ebiederm@xmission.com::42265c3f2d3cbad3767134ed4bc7c28b:71a53f4f8b49f5fe
x-hashcash: 1:21:150122:gnomes@lxorguk.ukuu.org.uk::c8e3b240df9849625f329a18f618cdcd:e7bc8cd62d1edb07
x-hashcash: 1:21:150122:teg@jklm.no::7b54a69a1bf670bb9a94c797fb7476:15c8261fdcac0cff
x-hashcash: 1:21:150122:jkosina@suse.cz::9a2c1b7f85040c5ec45a25d3da9148be:5b33834395c206dc
x-hashcash: 1:21:150122:luto@amacapital.net::c68c02ec887a606b9aa267e006301dae:26f5ba82c7646d32
x-hashcash: 1:21:150122:linux-api@vger.kernel.org::8a08c0eeacc4c8503ade01a973d1611f:8faef429edb303
x-hashcash: 1:21:150122:linux-kernel@vger.kernel.org::bdea65248faaaff37d9a1bca3e7b8472:cc7ed4ab4054d3c1
x-hashcash: 1:21:150122:tixxdz@opendz.org::2648fcd86e5f731b3b3c1dcac11e3f88:69b2bdf04e2d15f9
x-hashcash: 1:21:150122:js@sig21.net::20ad3480da49aacba7466d345c02abcb:9cb607ef3b15854e
x-hashcash: 1:21:150122:tytso@mit.edu::f9be53f1fc61f9416642a7a241f65b27:a1e5583e70725b2d
x-stampprotocols: hashcash:1:17;mbound:0:10:3000:5000
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010005020709040000080309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms010005020709040000080309
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-01-22 08:46, David Herrmann wrote:
> Hi Michael
>
> On Thu, Jan 22, 2015 at 11:18 AM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> * API oddities such as the 'kernel_flags' fields. Why do I need to
>>    be told what flags the kernel supports on *every* operation?
>
> If we only returned EINVAL on invalid arguments, user-space had to
> probe for each flag to see whether it's supported. By returning the
> set of supported flags, user-space can cache those and _reliably_ know
> which flags are supported.
> We decided the overhead of a single u64 copy on each ioctl is
> preferred over a separate syscall/ioctl to query kernel flags. If you
> disagree, please elaborate (preferably with a suggestion how to do it
> better).
>
While I agree that there should be a way for userspace to get the list=20
of supported operations, userspace apps will only actually care about=20
that once, when they begin talking to kdbus, because (ignoring the live=20
kernel patching that people have been working on recently) the list of=20
supported operations isn't going to change while the system is running.=20
  While a u64 copy has relatively low overhead, it does have overhead,=20
and that is very significant when you consider part of the reason some=20
people want kdbus is for the performance gain.  Especially for those=20
automotive applications that have been mentioned which fire off=20
thousands of messages during start-up, every little bit of performance=20
is significant.


--------------ms010005020709040000080309
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwMTIyMTQ0OTAw
WjAjBgkqhkiG9w0BCQQxFgQUEdvBYr83A67v9dopVIzsDhSDCIcwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAJJkCzgIBUD56mva3SXbVhefL769C
BSfUg5tNtqMwJ5PrZsEx12UqLfi1ahUoR0MMoyOC+6n8HwyghT9XywNOC+jr8t0kD7uPC1Vv
P5pAiKNl3CNNL7LtcuumaqmwUpFc5PRECxpsvOPPzjA0yJcqGPf5WrnD+IiF6FqeczWue3Hb
H2qNqkOdeAmcUXCZE7sKjrY42S/oXAVjL2lFBymVWTj9Gp3y1L6fiE/nM3e4eCTidkg1QoOz
ecs39yt97Ow78mhAVSeBfRYwLxyg8+QBXN5BCEu/Wf0LSu6GInOlGgVn2xLJwN5+s+BjvTAe
JxIt7Kzd+n7w9RvujxqVZAKDmQAAAAAAAA==
--------------ms010005020709040000080309--
