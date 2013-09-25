Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab3IYUgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:36:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46838 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429Ab3IYUgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:36:12 -0400
Date: Wed, 25 Sep 2013 15:35:58 -0500
From: Felipe Balbi <balbi@ti.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: <balbi@ti.com>, Pavel Machek <pavel@ucw.cz>,
        kernel list <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: Fix style in s3c-hsotg.c
Message-ID: <20130925203558.GV10746@radagast>
Reply-To: <balbi@ti.com>
References: <20130902135832.GA22300@amd.pavel.ucw.cz>
 <20130918092027.GA8325@amd.pavel.ucw.cz>
 <20130918141106.GH21559@radagast>
 <2758936.kqHJ9YzqCC@amdc1032>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oNLI4EWr1RPQuPCf"
Content-Disposition: inline
In-Reply-To: <2758936.kqHJ9YzqCC@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--oNLI4EWr1RPQuPCf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 25, 2013 at 05:39:39PM +0200, Bartlomiej Zolnierkiewicz wrote:
> Pavel, Felipe's remark was valid..
>=20
> > > No, I'll not polish patch for hardware I don't have and have little
> > > interest in.  wanted to help you, but according to your first reply,
> > > you do not really want help.
> >=20
> > that's your call. Now how about you stop being such a baby and go fix
> > your mistakes to start with ? Just because I'm the maintainer of the
> > gadget framework, doesn't mean I'm the maintainer of s3c-hsotc.c file.
> > Maintainer !=3D author too, btw.
> >=20
> > Anyway, I got much better stuff to do than babysitting grown ups.
>=20
> ..even if it could have been communicated in a gentler way.
>=20
> Anyway s3c-hsotg.c is a driver for our hardware so I'm going to pick this
> patch up, polish it and then re-submit it later. Thanks.

I tried a few times being nice and the response was always in the lines
of "you should go fix the patch yourself if you don't like it" (not
exactly these words, but same message). After some time of being nice
and get nowhere, I just got fed up.

cheers

--=20
balbi

--oNLI4EWr1RPQuPCf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQ0ktAAoJEIaOsuA1yqRE0asP/jIgs8AJ4P4JJDZnjJfhY15l
LBvFJP+CdFm76nyZUhfdoVzg3XdHKTEFOLeqpzQOz/Tsozo/MIJGvQScMU+L3EM6
eEhM6zS/Kx0MsXZm8k8nxws5CPfjZoUVb2noTSN9iS82LWuof7yzHiB1ppTb8g1q
6r6onw+l0vQ8V0yKKZR3MfJHMLl4kVUaDZe3hjXkQRF4FazDHu9DxVmfYfdDAXYA
wIRunnuxSiJbIcpK/dPYnLBpTn/Qjq3CZQmmahkDyma9IXyOobKIJSxDWXP1gAuq
A0GEISTRdzTYgByHe6ZVKSw3BosAHkneB6285mXRsEAVIXluup+Hyoup8md0yi5u
K4JsiP8fZwSzFvBEZzth1HSh8hZTf2sDLe6NTUUrvwJ5yrlVZP1ABrOQ37F+CpLZ
kXECbXzuuquF3oyn2HsS6Y1mXjcE3cbxogncge3kH6euBrLOeSLtXRXpgR6Ypckj
rIMfHeifQxQMLjifLcsma1SQ+GAa8wGpbLpA+zJr4RCl1meVF8/HmCelloHxNtxN
+/tzvaxaHdTooMEoDPSBzN1F3p6flu6Mkdk8R960S3FRLUpy16Hj2XMHWapp5TiY
QdtoP7RFK6HoTb1y3AN3yXSFBCuWvHMWyuOdNdNHA2aRl7O+cyJsvZFWjeKORoxh
P9xGmRbmIjydkU+CK9FZ
=4Bdu
-----END PGP SIGNATURE-----

--oNLI4EWr1RPQuPCf--
