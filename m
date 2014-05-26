Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaEZMXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 08:23:35 -0400
Received: from mout.gmx.net ([212.227.17.21]:64742 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaEZMXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 08:23:34 -0400
Message-ID: <5383323E.7060208@gmx.de>
Date: Mon, 26 May 2014 14:23:26 +0200
From: =?UTF-8?B?TWFsdGUgU2NocsO2ZGVy?= <maltesch@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Woody Suwalski <terraluna977@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: Radeon wakeup regression in 3.15-rc6
References: <53805C4E.7050205@gmx.de> <5382E711.8050506@gmx.de>
In-Reply-To: <5382E711.8050506@gmx.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bCValNNBBdJtOd3JUv48jvQ9e9cDiVrdS"
X-Provags-ID: V03:K0:dBU90/B/uwb2vtDWFdI0njCni9O6qbRkX5gD1SPAos1InH9xCr8
 CaKAFDRSQ5qHmT8CWuLTzYMi4afyhiSXve0jn4h66tJ4+R9ZK+h7KVyDwanO2zc0TV8qZlH
 m1LDZpO17nygfEw+5AUlHtcBWWlo3StDSnJfK1ysKqOTX/XCFdY+gkeYwnopu3NO+cAHT9z
 ioTnN4tun7cR5Mta/4ZiA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bCValNNBBdJtOd3JUv48jvQ9e9cDiVrdS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 26.05.2014 09:02, Malte Schr=C3=B6der wrote:
> On 25.05.2014 14:56, Woody Suwalski wrote:
>> Malte Schr=C3=B6der wrote:
>>> Hi,
>>> I just tried 3.15-rc6. I encountered a pretty nasty problem, which is=

>>> after suspending to RAM the system doesn't wake up properly. v3.14 is=

>>> fine.
>>> On wakeup all seems fine, i.e. hd starts to spin an USB-stuff wakes u=
p.
>>> But all I get from the graphics card is a white screen slowly filling=

>>> with random colored pixels. I had to hard reset the system.
>>>
>>> I attached the kernel log, the X-servers log, lspci-output and my ker=
nel
>>> config.
>>>
>>> Regards
>>> Malte
>> I have seen a bit of a screen distortion at the bottom of LCD on Radeo=
n
>> after a wakeup.
>> I tried to re-run with drm.debug=3D0x0e, however once I did it - the
>> problem has disappeared, and I have not been able to duplicate it agai=
n.
>> So just watching for now.
>> OTOH I have seen (only one time) a black screen after wakeup on Nvidia=
=2E
>> So maybe some timing is now exposed in PM / DRM...
>>
>> Woody
>>
>>
>=20
> I pulled git://people.freedesktop.org/~deathsimple/linux drm-fixes-3.15=

>  from http://article.gmane.org/gmane.comp.video.dri.devel/106114 and my=

> problem is gone ...
>=20

Also fixed in v3.15-rc7.

/Malte



--bCValNNBBdJtOd3JUv48jvQ9e9cDiVrdS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJTgzI+AAoJEJhhoDgpnptoClsP/jeuImWhgzZcInK6s67NZpHD
AgMCpCHRbjAeCKpie1eN7RrIOfh2R6yja1M2CaDjGs5ZrXvxEqO+1IUXLLuN9jvR
IoNcqif0pHi98BRlQpNq9GTMUoojrrT7NoScHWXQnU8Ldn3V12a5L3ZLmExwFyew
ejbwo3Wh8b2qYqkEu7rQPZcgC4/p9llZtMtXlch/gNNwG2oRnr9XF7CXsk5SO0QE
hvQFWRkrbxpQdSw/KeK3Nhx9c5GuN6RedazDcEHqZF5hS9u3eRyrZWkHE8gf8Cqm
a9oeLOox6rVZc+UmBeFe+m9NtglmXlpt0F4T6ZWIEj6dchZ8rWCmAVytOI0WNeUX
5iZM7/76ILYpGMXzwqCCrLts4OtcVmfis481IGxS7Y71NSessoA3FklIV+9sR8M6
Gtj+jXuvUH3sTLWGInGo3mQ/J3DHG3vCwVfwUFnsVrayUA9dOfZCvxm1XuE0nI0u
vCWdg6yMJuaz8scOzVBLOvNLIiceKf9OXZLtccaCcceJdPSZq7Iw9j9zzXtBCewu
fZwDb4qijEW7GewdIQ2tnM5p3YKTnjqBKXxV35RLl40Cr35iLHZQvwsAqXyqBpms
UaVyyRyQHaV87XthAhnm1FC6oW4spMPKUB+zC9ukHYkK1Ur4SQ6xgJIQlt4+V500
l5T19HrF/PgZn57ehLFp
=I8Od
-----END PGP SIGNATURE-----

--bCValNNBBdJtOd3JUv48jvQ9e9cDiVrdS--
