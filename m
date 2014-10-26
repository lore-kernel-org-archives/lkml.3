Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaJZWXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 18:23:23 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37976 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaJZWXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 18:23:21 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: USB Ethernet gadget on Nokia n900
Date: Sun, 26 Oct 2014 23:23:17 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Felipe Balbi <balbi@ti.com>,
        sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
References: <20141019090107.GA19132@amd> <201410262222.39892@pali> <20141026215548.GA9004@amd>
In-Reply-To: <20141026215548.GA9004@amd>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6643605.or8oNfp26G";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201410262323.17891@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6643605.or8oNfp26G
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 26 October 2014 22:55:48 Pavel Machek wrote:
> > > I have root prepared on /dev/mmcblk0p6. I tried 3.17 with
> > > rx51_defconfig, but no, it refuses to mount it.
> > >=20
> > > VFS: Cannot open root device "mmcblk0p6" or ....: error
> > > -19.
> > >=20
> > > And then it proceeds to list mmcblk0p6 as one of available
> > > options
> > >=20
> > > :-(.
> > >=20
> > > Ideas welcome.
> >=20
> > Try to add rootdelay=3D30 or rootwait to kernel cmdline.
>=20
> I had rootdelay=3D3. Will try rootwait... no change. This is
> v3.17 with rx51_defconfig. CONFIG_MACH_NOKIA_RX51=3Dy =3D> device
> tree will not be used AFAICT.
>=20
> Now I'm back at 3.14 without device tree; same setup works
> there. I tried disabling RX51 support in 3.14 (to make it
> boot using device tree) but that did not work.
> 								Pavel

I remember that there was some problem with initializing mmc=20
device. Sometimes something failed and reading from eMMC was not=20
possible. Try to boot kernel from uboot. Maybe it can help.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart6643605.or8oNfp26G
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRNdFUACgkQi/DJPQPkQ1LJRQCeNfNlGny+NRrpOKwAfTsaWICH
5hYAoLXVxgyDDcxPmfo1IMnioS52JGeG
=acwd
-----END PGP SIGNATURE-----

--nextPart6643605.or8oNfp26G--
