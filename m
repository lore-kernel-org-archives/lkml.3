Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaAPRTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:19:49 -0500
Received: from imp01.mtu.ru ([62.5.255.10]:44980 "EHLO imp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbaAPRTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:19:47 -0500
X-Spam-Flag: NO
Message-ID: <52D814A8.8070105@pavlinux.ru>
Date: Thu, 16 Jan 2014 21:19:36 +0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH RT 0/8] Linux 3.2.53-rt76-rc1
References: <20140116015824.201732155@goodmis.org>	<52D7A93C.9090801@pavlinux.ru>	<20140116091847.0786c8af@gandalf.local.home>	<52D7EE70.8000509@pavlinux.ru> <20140116110823.26aad085@gandalf.local.home>
In-Reply-To: <20140116110823.26aad085@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="kR98lETc5JKhb8074nesNbbrfFKhP9gJe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kR98lETc5JKhb8074nesNbbrfFKhP9gJe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

16.01.2014 20:08, Steven Rostedt =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Thu, 16 Jan 2014 18:36:32 +0400
> Pavel Vasilyev <pavel@pavlinux.ru> wrote:
>=20
>>
>> $ xz -cd /tmp/patch-3.2.53-rt75-rt76-rc1.patch.xz | patch -p1 --dry-ru=
n

> Did you start with v3.2.53-rt75?

No, 3.2.54, already corrected.

--=20

                                                         Pavel.


--kR98lETc5JKhb8074nesNbbrfFKhP9gJe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCgAGBQJS2BSpAAoJEPtok08Dny2hJyAP/34ac2/LyA2bc9i57FGQnkzT
BUXzZ9V8GLvMpD881whDvvNyLA+bNghjJogR56e8MZ6rB7h3WZfHKPPSxA/PhFhz
bgYMc5P64xvkkZMbCNDJ0Hc99oZ0Qw1uBNGxUjHs3+0T7BLi3ctYcbKi7RFf/PAp
Xi4nNDW40NyJ3l7TIDkyD6/hlAwule/wyIqW1bbh0F4qrfgQbP2CH1a8lDlLsj1p
R6zC/45+C+E5IN7sOg9MX06MBhA0yGCae9Brc81PXfuLLrV3566c2Bw81vwnf+4u
powHDrUmvrkclFw0fVPYE9HZy1N2QhbvRWLsDjVQmHrD7X/T0QjI+PLwSQrprYNL
fFJmvA1c1kyAbLnMA4l65pLLTaIOgNi7M+ZICxxWQqH35VCLCT+BSw2jZ12lOHj1
Zn5+yWhXt6xFNlYq1jGzFnAeysZ43N150O+Ew4Fwx87YUSQ0oCpnvMwwh1P+XeHE
NHIIQEzS4o0qtTTuP935S4fOs9GrPUxeJf1rDYK9rKbTU+mplen5WQJLY4Vf/ucw
DZ4zGlZ2Wd0HMs+eOi3r2mLbT9QgoDCIIPcZZA4ebfIID4KAjP4QLYAdedwAE0xc
XEnn3dUVXZT4glOSo3Zrp9Vtr15FentfSY6YDTy2HDSI9vWlnrjyYRXKS+aR6KpQ
sWqZSJK5ybvOg5IugD0g
=13Qu
-----END PGP SIGNATURE-----

--kR98lETc5JKhb8074nesNbbrfFKhP9gJe--
