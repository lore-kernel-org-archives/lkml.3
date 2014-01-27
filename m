Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbaA0JnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:43:17 -0500
Received: from imp02.mtu.ru ([62.5.255.19]:42952 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaA0JnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:43:15 -0500
X-Spam-Flag: NO
Message-ID: <52E62A05.7080802@pavlinux.ru>
Date: Mon, 27 Jan 2014 13:42:29 +0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.8-rt11
References: <20140125134519.GA9845@linutronix.de> <52E57D42.60206@pavlinux.ru> <52E61C52.6070104@linutronix.de>
In-Reply-To: <52E61C52.6070104@linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="2eNboSgqvcQt5Pw8pNkF8CvIXS2XkbI0L"
X-DCC-STREAM-Metrics: ss27-so02.mtu.ru 10001; Body=6 Fuz1=6 Fuz2=6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2eNboSgqvcQt5Pw8pNkF8CvIXS2XkbI0L
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

27.01.2014 12:44, Sebastian Andrzej Siewior =D0=BF=D0=B8=D1=88=D0=B5=D1=82=
:
> On 01/26/2014 10:25 PM, Pavel Vasilyev wrote:
>> 25.01.2014 17:45, Sebastian Andrzej Siewior =D0=BF=D0=B8=D1=88=D0=B5=D1=
=82:
>>> Dear RT folks!
>>
>>
>> Gentlemen, let's have a month of stress testing! Divide tasks
>> testing subsystem: USB, NET, MM, ACPI, AUDIO, VIDEO By CPUs:
>> ARM/PPC/X86/X86_64...
>>
>> Purely on observations noted that in September 2013, the quality
>> and stability of the code has deteriorated dramatically.
>=20
> By September 2k13, do you mean a specific v3.10-RT release?
>=20

Any after 3.2.x-rt

Maybe I'm doing something wrong, but:

1) All kernels (3.2, 3.8, 3.12, 3.13,...) are working normally without pa=
tches;

2) 3.2 works fine in CONFIG_PREEMPT_RT_BASE or CONFIG_PREEMPT_RT_FULL mod=
es;

3) 3.10 not works at all, even without -RT patches;

4) 3.12 work only as CONFIG_PREEMPT_RT_BASE or CONFIG_PREEMPT_RT_FULL in
uniprocessor mode (maxcpus=3D0, nosmp).  Newer patches (Oct.-Dec.) did no=
t work,
even in RT_BASE mode.

Varia hardware: One Opteron 285, 2-cpus (4 cores). Six Intel Atoms device=
s
kernels compiled as x86_32.

I have my patches, but I tested both with them and without them.
---

Behold! 3.12.8-rt11, RT_FULL mode, kernel cmdline: init=3D/bin/bash

1.
bash: cannot set terminal process group (-1): Inappropriate ioctl for dev=
ice
bash: no job control in this shell

2.
in single mode: After 2 minutes timeout: see screenshot
http://i59.fastpic.ru/big/2014/0127/bc/0f9e04536181286f820ecaae5a8481bc.j=
pg

3.
command killall -15 freezed system!


Kernel compiled with debug information starts to work normally, but of co=
urse
slower. :D

--=20

                                                         Pavel.


--2eNboSgqvcQt5Pw8pNkF8CvIXS2XkbI0L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCgAGBQJS5ioFAAoJEPtok08Dny2hpr4P+gJy9v+s4W0M8fjVJKcb/mwH
SwR4gbiIMRSLtCWneO+BCSQ+Jcwa2N7N5TM3dVFJovOAZIW9HsbuIWGJWJKv1nvc
CTu1kKPy27YwrCSZJBEHqeX4yxnuzrgInbrapHm3S0ssG/RZwHbdJvJ74TkYnA/0
VXJYowyalpbrb1HIH84UUcuGhREhtSCAKLf0Yg3IZhO3RFESvOHXUxJYJkWl13c6
o1NLkQh8cM4tuQG8qtdu16tXzWgH2Xfi4EsoEfB7DsYodQGwMC95SdMrSj48NUd6
7uJ85EVGoOaAs8DMznpGdXkkYC9CJKXwmlIbhpxn9q2oHXKuAjy312J7ulODWbTw
BPRpojT38il+z186sXJDbbPTC2Hc4j5HAxh2pSnrbu1Bx3gOWJAf4eXwhoVMgMUK
S5kZ5AxIsBrk3iVZltEWJ4g/ZYIwMY2hh8oJN7zzBiX3ewFV2UpIcCfMqiphjZJC
2ePd+q49ZhnqjpIHZA84BthBN+fJxBeqal4Ys6f5BI5yoY/MvrCTan5FM1UpN3bn
OHASDTwHe/pnsgEgEev97HSpSZNdcK108lrr/dihybjdpQYzZuKE/Q20osGOlBsG
xiVR6UeqYuYS1vNVgUjehYwPl1X3QTMW3YQcedOqAJyaovUUBHdbYIvNEN/qGTm1
pYzdUuEDdxndr76Cp0Zu
=aCC3
-----END PGP SIGNATURE-----

--2eNboSgqvcQt5Pw8pNkF8CvIXS2XkbI0L--
