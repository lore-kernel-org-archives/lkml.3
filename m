Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3HEHbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:31:37 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:42160 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab3HEHbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:31:36 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Subject: Re: leds-lp5523: Broken commit db6eaf8388a413a5ee1b4547ce78506b9c6456b0
Date: Mon, 5 Aug 2013 09:31:26 +0200
User-Agent: KMail/1.13.7 (Linux/3.10.0-rc7+radeon+synaptics-generic; KDE/4.10.5; x86_64; ; )
Cc: Bryan Wu <cooloney@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201308041146.03970@pali> <A874F61F95741C4A9BA573A70FE3998F82E85CC4@DQHE06.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E85CC4@DQHE06.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1813395.L3IPpy2nM0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201308050931.26353@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1813395.L3IPpy2nM0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 05 August 2013 09:26:46 Kim, Milo wrote:
> > Hello,
> >=20
> > git commit "leds-lp5523: use generic firmware interface"
> > db6eaf8388a413a5ee1b4547ce78506b9c6456b0 introduced in
> > kernel 3.10 changed user space API for modifing lp5523 led
> > patterns via /sys.
> >=20
> > Before this commit there were sysfs attributes engineX_mode,
> > engineX_load and engineX_leds (for every engine X).
> >=20
> > Now (after commit) there are sysfs attributes:
> > select_engine, loading and data (see:
> > 10c06d178df11b0b2b746321a80ea14241997127 for description).
> > Old sysfs attributes were removed.
> >=20
> > So commit db6eaf8388a413a5ee1b4547ce78506b9c6456b0 totally
> > broke all existing userspace applications which use lp5523
> > leds.
> >=20
> > This also broke application MCE which is used on Nokia N900
> > phone for changing LED patterns in lp5523 led.
>=20
> First of all, I'm really sorry for this conflict.
>=20
> > I think that kernel api which is used by userspace
> > applications (like attributes in /sys) should not be
> > changed in way that totally broke existing applications.
> >=20
> > Can you fix this api problem? (maybe adding old sysfs
> > attributes which would call new api function...)
>=20
> I'll recover old sysfs attributes and implement them by using
> new functions. Additionally, I'll do same works in LP5521
> driver also.
>=20
> Best Regards,
> Milo

Hi, thank you very much!

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1813395.L3IPpy2nM0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlH/VM4ACgkQi/DJPQPkQ1KhlwCbB9XupyRcTtRJFt3JW4f0gEzi
6D8Aniv8MSKwEt5uWD1VbIWwUJ1s5RPE
=ZCX+
-----END PGP SIGNATURE-----

--nextPart1813395.L3IPpy2nM0--
