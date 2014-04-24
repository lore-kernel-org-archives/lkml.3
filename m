Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbaDXOsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:48:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43273 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757419AbaDXOsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:48:33 -0400
Date: Thu, 24 Apr 2014 09:48:22 -0500
From: Felipe Balbi <balbi@ti.com>
To: Balaji T K <balajitk@ti.com>
CC: <balbi@ti.com>, <chris@printf.net>, <ulf.hansson@linaro.org>,
        <linux-mmc@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] mmc: host: omap_hsmmc: a few improvements
Message-ID: <20140424144822.GJ26661@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395878690-9650-1-git-send-email-balbi@ti.com>
 <53592037.8050106@ti.com>
 <20140424143931.GE26661@saruman.home>
 <53592304.3070105@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KjX7LgAomYr70Ka9"
Content-Disposition: inline
In-Reply-To: <53592304.3070105@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KjX7LgAomYr70Ka9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2014 at 08:13:16PM +0530, Balaji T K wrote:
> On Thursday 24 April 2014 08:09 PM, Felipe Balbi wrote:
> >On Thu, Apr 24, 2014 at 08:01:19PM +0530, Balaji T K wrote:
> >>On Thursday 27 March 2014 05:34 AM, Felipe Balbi wrote:
> >>>Hi,
> >>>
> >>>this series lets us access the newer registers introduced
> >>>back in OMAP4 which give us some valid information about
> >>>the OMAP HSMMC IP like max block size, support for ADMA,
> >>>support for Retention.
> >>
> >>"Support for Retention" looks interesting, can you shed more lights on
> >>it
> >
> >HWINFO has a bit (bit 6) which tells you whether retention is supported,
> >it's in all TRMs since OMAP3630 or so.
> >
> >"6	RERETMODE		Retention mode generic parameter
> >				This bit field indicates whether the
> >				retention mode is supported using the
> >				pin PIRFFRET.
> >
> >				0x0: Retention mode disabled
> >				0x1: Retention mode enabled"
> >
>=20
> I have seen that but just wondering how the driver can make use of it
> :-)

oh, perhaps you can use to conditionally save context. The difficulty is
knowing if we're going to RET or OFF, but that could be extrapolated
=66rom pm_qos, perhaps ?!?

just a thought.

--=20
balbi

--KjX7LgAomYr70Ka9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWSQ2AAoJEIaOsuA1yqREisMP/18DgeQ2YsZhdnUQN26MpyKT
FtyEVUpna9AbJ5lhwAcQ8XRqsjikxXZqXgY2zOJ6d78zjSQmkKBTslxXH7kXEpj0
2/THK1NdsIE1is7E/dM92nSXlwAbGCTbcWopr1tSAiO4QL+Ipek3lqtDDkX/uvup
0BThWNEGtk5Kd8Au5JP6Nk1rl6fT+t7TQ8CQ6arKcOLCbnC2BKHgmguQGifJJeaT
BdajhfIwYwW0mawKILd0lXsvzC21Gu8rT9XKGNea3Wx3+GeYvWoNDUWRCGdLQIDh
ZY6/650dBLL9+x9TIZubNbG0OSjSa5ShKESq4aunVFroSugIScZKshpEptI5ZSKS
oSX3Z4xT+tGxMb3w1Z8+LrFqf6QxbimRvsQgXmQI90G4tZY9PjocyALJD/ugeSmz
EEdqPJn2i/bU1NIoDfBeNiUNeRzGrGj9IKCBjIeQwIe7wTeOnMi7QLIZ7LrwFHWE
M4ovAFK16Hb3OtrNbE11EOlBs+MYZX22/afR1Ip5Gg+hEQ+ANJVPqcABRcGxfUDU
s4LFs/DyAD6lN2yN0WQYXo2xi0DyshV6qpvAonmaCfUO3ae4Mvi42cWjXTmXkrge
G2HEEqFPGRxl3aEW+2ucXB4gpn8bf/KPjwo4dCcoqG7U098HWCJGu6WGTKklM8cm
s4s8gHaKADG5Lk/3noFD
=EC27
-----END PGP SIGNATURE-----

--KjX7LgAomYr70Ka9--
