Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaLFSIx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 13:08:53 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:42106 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaLFSIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 13:08:50 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: N900: fixing MMC at boot
Date: Sat, 6 Dec 2014 19:08:46 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: sre@debian.org, sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
References: <20141206173526.GA7964@amd> <201412061840.16157@pali> <20141206180429.GA312@amd>
In-Reply-To: <20141206180429.GA312@amd>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2402645.slvSIkAGTB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412061908.46854@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2402645.slvSIkAGTB
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 06 December 2014 19:04:29 Pavel Machek wrote:
> On Sat 2014-12-06 18:40:16, Pali Roh=C3=A1r wrote:
> > On Saturday 06 December 2014 18:35:27 Pavel Machek wrote:
> > > Hi!
> > >=20
> > > For a long time, MMC was not working during boot...
> > > (making the box unusable without nfsroot). It seems
> > > problem is in the regulators, because with diff below, I
> > > was able to mount root on SD card for a first time ... in
> > > a long time.
> >=20
> > Hi, do you mean external SD card or internal eMMC (MyDocs)?
>=20
> I mean u-SD card. But it is strange. I reverted the patch now,
> and it still works. Not sure why or what I've done
> differently.
>=20
> 									Pavel

Remove battery wait some time and try again. Maybe you configured=20
something which can be cleared only after full device shutdown...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2402645.slvSIkAGTB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSDRi4ACgkQi/DJPQPkQ1JSywCgwLUKkxBhiC7cg38715KPmZNa
AwoAoLyyrzQQkmijtNXYZtJ4hfdJ65QF
=M/Bg
-----END PGP SIGNATURE-----

--nextPart2402645.slvSIkAGTB--
