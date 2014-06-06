Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaFFKYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:24:10 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:57985 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbaFFKYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:24:05 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH v2] platform: x86: dell-smo8800: Dell Latitude freefall driver (ACPI SMO8800/SMO8810)
Date: Fri, 6 Jun 2014 12:24:01 +0200
User-Agent: KMail/1.13.7 (Linux/3.15.0-031500rc3-generic; KDE/4.13.0; x86_64; ; )
Cc: Randy Dunlap <rdunlap@infradead.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Sonal Santan <sonal.santan@gmail.com>
References: <1399114077-19314-2-git-send-email-pali.rohar@gmail.com> <1400757348-5351-1-git-send-email-pali.rohar@gmail.com> <201405281531.30298@pali>
In-Reply-To: <201405281531.30298@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1608987.9lQ7NXdIOo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201406061224.01615@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1608987.9lQ7NXdIOo
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 28 May 2014 15:31:30 Pali Roh=C3=A1r wrote:
> On Thursday 22 May 2014 13:15:48 Pali Roh=C3=A1r wrote:
> > This acpi driver provide supports for freefall sensors
> > SMO8800/SMO8810 which can be found on Dell Latitude laptops.
> > Driver register /dev/freefall misc device which has same
> > interface as driver hp_accel freefall driver. So any
> > existing applications for HP freefall sensor /dev/freefall
> > will work for with this new driver for Dell Latitude
> > laptops too.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > Cc: Sonal Santan <sonal.santan@gmail.com>
> > Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> > Acked-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> > ---
> > Changes since v1:
> > * Fixed warnings: Missing a blank line after declarations
> > * Fixed Lowercase ON in Kconfig
> > * Fixed Alan's review problems by Sonal Santan
> > ---
> >=20
> >  drivers/platform/x86/Kconfig        |   10 ++
> >  drivers/platform/x86/Makefile       |    1 +
> >  drivers/platform/x86/dell-smo8800.c |  233
> >=20
> > +++++++++++++++++++++++++++++++++++ 3 files changed, 244
> > insertions(+)
> >=20
> >  create mode 100644 drivers/platform/x86/dell-smo8800.c
>=20
> After week there are no other objections.
>=20
> Matthew Garrett, can you apply driver into platform tree?

PING.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1608987.9lQ7NXdIOo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlORlsEACgkQi/DJPQPkQ1Lx9wCdG/zyFRNlMw9/WwxJfAD0Y4ec
dKsAniWyYRHu2BcIwg4fEWgVRvGc9QcS
=mlSw
-----END PGP SIGNATURE-----

--nextPart1608987.9lQ7NXdIOo--
