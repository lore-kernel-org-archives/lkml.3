Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965097AbaD3UMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:12:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42102 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbaD3UMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:12:12 -0400
Date: Wed, 30 Apr 2014 15:12:02 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Fertser <fercerpav@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Li Yang <leoli@freescale.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <suresh.gupta@freescale.com>
Subject: Re: [PATCH] usb: gadget: fsl: check vbus presence on probe
Message-ID: <20140430201202.GF3839@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398329653-29968-1-git-send-email-fercerpav@gmail.com>
 <20140430160625.GF23679@saruman.home>
 <20140430192745.GI3876@home.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pE2VAHO2njSJCslu"
Content-Disposition: inline
In-Reply-To: <20140430192745.GI3876@home.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pE2VAHO2njSJCslu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

+Suresh

(top-posting, yeah yeah :-)

On Wed, Apr 30, 2014 at 11:27:45PM +0400, Paul Fertser wrote:
> Hello,
>=20
> Thank you for the review.
>=20
> On Wed, Apr 30, 2014 at 11:06:25AM -0500, Felipe Balbi wrote:
> > On Thu, Apr 24, 2014 at 12:54:13PM +0400, Paul Fertser wrote:
> > > If VBUS is already present during the driver initialisation, the
> >=20
> > s/initialisation/initialization
>=20
> If I'm understanding [1] properly, both spelling variants are correct.
>=20
> > > +	/* Now let it settle a bit and sense VBUS */
> > > +	msleep_interruptible(1);
> > > +	if (fsl_readl(&dr_regs->otgsc) & OTGSC_STS_B_SESSION_VALID)
> > > +		udc_controller->vbus_active =3D 1;
> >=20
> > good fix, should this go to stable ?
>=20
> I was reluctant to Cc stable because I'm not sure which versions need
> to be fixed, as I've seen an earlier version (3.0 something or a bit
> before that probably) working without this (no idea why); also I'm not
> sure about that msleep as it's deduced solely from experimenting with
> a particular i.MX model, I hoped someone from Freescale would comment
> on it. I've seen your review [2] on a related patch and my fix should
> have been obvious to Suresh (and trivial to test on different boards),
> yet he didn't implement it, that worries me a bit.
>=20
> [1] https://en.wikipedia.org/wiki/American_and_British_English_spelling_d=
ifferences#-ise.2C_-ize_.28-isation.2C_-ization.29
> [2] https://patchwork.kernel.org/patch/3822321/
> --=20
> Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
> mailto:fercerpav@gmail.com

--=20
balbi

--pE2VAHO2njSJCslu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYVkSAAoJEIaOsuA1yqRE9R8P/jU+mggXdR9vMC/e++73cYx5
pXQhX8fC+FaB8FZba86A3IlplV9YMprzQXOB0zXRIBEIHuAY5lbJZWeO6Yv5Y3H8
5Gz9S4/ZiFZavMFpA4YTSH2y4dF2qdBUWPvrZw/0F4Cbdkfx3rU8IrktqmwggVL7
ZEYqV91EgIYVRuETLOIWHN0FfwaV+y5aeGTv349sQGKw86rGTNwhTQruboeqbTo6
/2NcSYZcTKmNnKABcc9nJ1drRFWN34rZxUoXDphc91Vs0X528f8i0WQZe0iYJXnW
JGVyzfcviTejGPHD72wrrJb9wrBQyzh2J39M7RU82Hber+JdQpWa5tzjl8BqCYWW
U9l5CX2SQv3opCWTutBDoOdFYJcU0pSSYPK3znJ+PubuVN47Pp1vvnTx07NttvcF
NhGYoy/YczCdNv8FSB0/eWlF+vGZt6QZzGE115I7+aItDh6k/Jyb8odGgK19dOAA
Kt4HwXtWxK6KRmkjhenk3zFYQi+GltmLVtpSfSVpswqo2kDzKQTWE8X9lZkObstz
y/gN67WdpZ7833YqZ3WCdw3F96dN9Jy+QiBJ+rx53H6SZlWVfVScWVjlBwHvAQ8Z
m4tt/hw0kMJFkp1OoEg6/W9thMwG9ie08lFqpP9PTkVPLqf8d9ev+cf5PP/jtPFM
l59HDchHwNkIOI+7drAv
=EGri
-----END PGP SIGNATURE-----

--pE2VAHO2njSJCslu--
