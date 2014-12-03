Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaLCMqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:46:19 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:57627 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaLCMqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:46:17 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Side effect of pressing special keys
Date: Wed, 3 Dec 2014 13:46:13 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        linux-kernel@vger.kernel.org
References: <201411231441.17592@pali> <20141203124042.GA504@amd>
In-Reply-To: <20141203124042.GA504@amd>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4977575.d8P1Ez9mSK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412031346.13297@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4977575.d8P1Ez9mSK
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 03 December 2014 13:40:42 Pavel Machek wrote:
> On Sun 2014-11-23 14:41:17, Pali Roh=C3=A1r wrote:
> > Hello,
> >=20
> > pressing some keys on laptops could cause some side effects.
> >=20
> > Example scenario 1:
> >=20
> > Laptop has Fn key for enabling/disabling WIFI and when that
> > key is pressed BIOS is doing two things:
> >=20
> > 1) Switch hard rfkill state of WIFI
> > 2) Report that Fn key was pressed to kernel
> >=20
> >    (either via i8042 bus or via ACPI/WMI)
>=20
> We should not really report that as a "key" to userspace. We
> might want to report that rfkill state changed....
> 							Pavel

Ok, and what about KEY_KBDILLUMTOGGLE when bios also handle=20
keyboard backlight level? Should be this key filtered too?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart4977575.d8P1Ez9mSK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR/BhUACgkQi/DJPQPkQ1I3ZwCgzkushW86QTVF6VNvwjt1Q9Ah
aoAAoKZ8a504jsdosY/cV4dDD4Fign8Z
=2cRj
-----END PGP SIGNATURE-----

--nextPart4977575.d8P1Ez9mSK--
