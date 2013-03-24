Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3CXOTz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 10:19:55 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:52539 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3CXOTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 10:19:53 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2] ADP1653 board code for Nokia RX-51
Date: Sun, 24 Mar 2013 15:19:49 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-27-generic; KDE/4.10.1; x86_64; ; )
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201302171616.50152@pali> <20130306214440.GA11874@earth.universe> <20130307221827.GE31984@valkosipuli.retiisi.org.uk>
In-Reply-To: <20130307221827.GE31984@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5714163.pOYO2Fqk82";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201303241519.49243@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5714163.pOYO2Fqk82
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 07 March 2013 23:18:27 Sakari Ailus wrote:
> Hi guys,
>=20
> On Wed, Mar 06, 2013 at 10:44:41PM +0100, Sebastian Reichel=20
wrote:
> > On Wed, Mar 06, 2013 at 09:20:16PM +0100, Pali Roh=C3=A1r wrote:
> > > On Wednesday 06 March 2013 21:12:06 Pali Roh=C3=A1r wrote:
> > > > On Sunday 17 February 2013 20:03:03 Aaro Koskinen wrote:
> > > > > On Sun, Feb 17, 2013 at 04:16:49PM +0100, Pali Roh=C3=A1r=20
wrote:
> > > > > > +/*
> > > > > > + * arch/arm/mach-omap2/board-rx51-camera.c
> > > > > > + *
> > > > > > + * Copyright (C) 2008 Nokia Corporation
> > > > > > + *
> > > > > > + * Contact: Sakari Ailus <sakari.ailus@nokia.com>
> > > > > > + *          Tuukka Toivonen
> > > > > > <tuukka.o.toivonen@nokia.com>
> > > > >=20
> > > > > You should put these people to CC... Just to see if
> > > > > the addresses are still valid (which I doubt).
> > > >=20
> > > > Ok, trying :-)
> > >=20
> > > I got "Delivery Status Notification (Failure)" for both
> > > addresses.
>=20
> This is expected.
>=20
> > Sakari Ailus hosts some code on github [0], which has the
> > following email address:
> > sakari.ailus+gitorious@retiisi.org.uk
> >=20
> > I added it to this mail's CC.
> >=20
> > [0] https://gitorious.org/~sailus
>=20
> Nice to hear people are interested in this. ;-)
>=20
> The primary reason I haven't tried submitting this to mainline
> is that ARM board code has a bad reputation these days. The
> N900 does not have yet support for device tree (AFAIK), which
> also would require a few bits and pieces on the flash driver
> to work.
>=20
> Also the sensor and lens drivers would need at least some work
> before being ready for submission to mainline for camera to
> be usable. Unfortunately I haven't had recently time to work
> on this. N9(50) support has higher priority for myself. That,
> too, is pending the DT support for the device.
>=20
> There's indeed more up-to-date code in my repository. Even if
> it's not too close to mainline anymore it should be a better
> starting point than the old kernel from MeeGo.
>=20
> <URL:https://gitorious.org/omap3camera/pages/Home>

Hi,

this board code is same in your git repository and on meego obs.

Patch only adding support for adp1653 driver which is already in=20
upstream kernel.

Are there any other problems with this patch to go for upstream?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart5714163.pOYO2Fqk82
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFPC4UACgkQi/DJPQPkQ1LgqACgrDMtXYsc4V/Pt3gYXG3Xloro
Il8AnRmc3Ji/3DaWe6tW4FfV/49iWIHY
=lr8M
-----END PGP SIGNATURE-----

--nextPart5714163.pOYO2Fqk82--
