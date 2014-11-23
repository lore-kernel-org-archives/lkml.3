Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaKWCic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 21:38:32 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49223 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbaKWCia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 21:38:30 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH] dell-smo8800: Add more acpi ids and change description of driver
Date: Sun, 23 Nov 2014 03:38:26 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
References: <1411994748-11229-1-git-send-email-pali.rohar@gmail.com> <20140929205604.GA34181@vmdeb7>
In-Reply-To: <20140929205604.GA34181@vmdeb7>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6883331.XbimRxxLkg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411230338.26239@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6883331.XbimRxxLkg
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Oops, I lost this mail somewhere...

I copied these ids from windows driver inf file. I did not tested=20
them because I do not have machine which reports these ids. It=20
looks like all SMOXX devices have same acpi structure (one IRQ).=20
So adding ids could not break anything (if acpi device will not=20
have for some reason IRQ specified, device probe function will=20
fail).

On Monday 29 September 2014 22:56:04 Darren Hart wrote:
> On Mon, Sep 29, 2014 at 02:45:48PM +0200, Pali Roh=C3=A1r wrote:
>=20
> Please see Documentation/SubmittingPatches, 15) The canonical
> patch format, and provide a complete message body.
>=20
> Have you validated each of the 6 ACPI IDs added to the driver?
>=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > ---
> >=20
> >  drivers/platform/x86/Kconfig        |    4 ++--
> >  drivers/platform/x86/dell-smo8800.c |   10 ++++++++--
> >  2 files changed, 10 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/drivers/platform/x86/Kconfig
> > b/drivers/platform/x86/Kconfig index 3bbcbf1..ba9ee4f
> > 100644
> > --- a/drivers/platform/x86/Kconfig
> > +++ b/drivers/platform/x86/Kconfig
> > @@ -128,10 +128,10 @@ config DELL_WMI_AIO
> >=20
> >  	  be called dell-wmi-aio.
> > =20
> >  config DELL_SMO8800
> >=20
> > -	tristate "Dell Latitude freefall driver (ACPI
> > SMO8800/SMO8810)" +	tristate "Dell Latitude freefall driver
> > (ACPI SMO88XX)"
> >=20
> >  	depends on ACPI
> >  	---help---
> >=20
> > -	  Say Y here if you want to support SMO8800/SMO8810
> > freefall device +	  Say Y here if you want to support
> > SMO88XX freefall device
>=20
> "devices" now that multiple are supported.
>=20
> Thanks,

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart6883331.XbimRxxLkg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRxSKIACgkQi/DJPQPkQ1KEsQCfRHE6j4rK/tFTyr2gsAtwkfLa
RAQAnjq2Ed4wsAvvWHCJG2kLgK3Irp20
=eAn1
-----END PGP SIGNATURE-----

--nextPart6883331.XbimRxxLkg--
