Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaKCUnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:43:40 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54794 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbaKCUni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:43:38 -0500
Date: Mon, 3 Nov 2014 14:43:04 -0600
From: Felipe Balbi <balbi@ti.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Felipe Balbi <balbi@ti.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>, <nsekhar@ti.com>,
        <grant.likely@linaro.org>, George Cherian <george.cherian@ti.com>
Subject: Re: [PATCH 1/4] extcon: gpio: Convert the driver to use gpio desc
 API's
Message-ID: <20141103204304.GC17356@saruman>
Reply-To: <balbi@ti.com>
References: <1415032350-8459-1-git-send-email-balbi@ti.com>
 <1415032350-8459-2-git-send-email-balbi@ti.com>
 <20141103180150.GA10164@roeck-us.net>
 <20141103180602.GU27425@saruman>
 <20141103185101.GC10558@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DIOMP1UsTsWJauNi"
Content-Disposition: inline
In-Reply-To: <20141103185101.GC10558@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DIOMP1UsTsWJauNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 03, 2014 at 10:51:08AM -0800, Guenter Roeck wrote:
> On Mon, Nov 03, 2014 at 12:06:02PM -0600, Felipe Balbi wrote:
> > On Mon, Nov 03, 2014 at 10:01:50AM -0800, Guenter Roeck wrote:
> > > On Mon, Nov 03, 2014 at 10:32:27AM -0600, Felipe Balbi wrote:
> > > > From: George Cherian <george.cherian@ti.com>
> > > >=20
> > > > Convert the driver to use gpiod_* API's.
> > > >=20
> > > > Reviewed-by: Roger Quadros <rogerq@ti.com>
> > > > Signed-off-by: George Cherian <george.cherian@ti.com>
> > > > Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> > > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > > ---
> > >=20
> > > I think it might be useful and appropriate to explain that and why
> > > you remove support for active-low pins, instead of hiding it in a
> > > seemingly unrelated patch.
> >=20
> > removed ? why removed ? gpio descs handle that for you, read the source
> > code.
> >=20
> Well, it for sure looks like it. Care to explain that in the patch,
> as well as how the platform data flag is used ?

I'll leave that to $author, I just cherry-picked and tested them.
Certainly that commit log needs some love.

--=20
balbi

--DIOMP1UsTsWJauNi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV+jYAAoJEIaOsuA1yqRE+WIP/23zDMklzhoK4JYGU2XpOfkM
8s+x8C547vsLBadY2WOLW7khPu8aLyw2fj3iXh7OKx6ZRD958JdUKKhwvQnJbAGA
NOs6QRrfhfyMG3xbb3pIv1GRRajPwrhPPyoSMPoVbOmort5KXPOur2qUuaS8nyBR
3AIZglADyDQcR/hDQvfHxqj2gfpUXEoHd2ZuwrI4IkupguC45WWK/BYfF2hKGeJr
12zSYvm1cQ7bkiwJftPMpLCzSUGf/OW1FE/n42bCcimhM/vUWu9nt8H/BBqIzYF2
k9hzFZnoRyE2iLPSCwZ7EHTbU1hyGNwSFkru/82tDVcbG+llr2QkNrxO8I3DiDEq
HhuyzvsZR2qS0l0SSAS8Ms0W5YcFTqSkWOnMzWh2lKXod7efSmKQllhP8iHDsMOF
FJk5QjMXC4PZ8m2yTzOgWpXXI6sZnyXpzO3iVEqCqzZkTY878iUib7SbLU6GYDTT
Ph3dd6n5/v7uHsDRrCz/0krRbN1FsIL5i379rk1f3vvSgqtPUU89kl2gat1loRD0
o0uDsMFVFXDUj8I/ePf8BQSKcXPzC9BcG1gps7X/Opqo1YfSPBsBw3FKkTD0mg7i
Rr6OyMWWntB+KY+X+4ydg3gP8BIYWRS+HIeyGXLVOL/10qvx/ocuMb+TLDozEqHM
6dT80Y8cftb9NLpoy74s
=a5M1
-----END PGP SIGNATURE-----

--DIOMP1UsTsWJauNi--
