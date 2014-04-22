Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbaDVPvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:51:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46878 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462AbaDVPva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:51:30 -0400
Date: Tue, 22 Apr 2014 10:48:58 -0500
From: Felipe Balbi <balbi@ti.com>
To: Balaji T K <balajitk@ti.com>
CC: <balbi@ti.com>, <chris@printf.net>, <ulf.hansson@linaro.org>,
        <linux-mmc@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] mmc: host: omap_hsmmc: a few improvements
Message-ID: <20140422154858.GN5524@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395878690-9650-1-git-send-email-balbi@ti.com>
 <20140421173203.GH22794@saruman.home>
 <53568B04.4050703@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DRfr/2Y1Zz/5r+Kb"
Content-Disposition: inline
In-Reply-To: <53568B04.4050703@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DRfr/2Y1Zz/5r+Kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 22, 2014 at 09:00:12PM +0530, Balaji T K wrote:
> On Monday 21 April 2014 11:02 PM, Felipe Balbi wrote:
> >Hi,
> >
> >On Wed, Mar 26, 2014 at 07:04:45PM -0500, Felipe Balbi wrote:
> >>this series lets us access the newer registers introduced
> >>back in OMAP4 which give us some valid information about
> >>the OMAP HSMMC IP like max block size, support for ADMA,
> >>support for Retention.
> >>
> >>Right now, only setting max_blk_size correctly as supporting
> >>ADMA and Retention will take a lot of work.
> >>
> >>Tested on OMAP5 uEVM.
> >>
> >>Felipe Balbi (5):
> >>   mmc: host: omap_hsmmc: pass host as an argument
> >>   mmc: host: omap_hsmmc: add reg_offset field
> >>   mmc: host: omap_hsmmc: introduce new accessor functions
> >>   mmc: host: omap_hsmmc: switch over to new accessors
> >>   mmc: host: omap_hsmmc: set max_blk_size correctly
>=20
> Got mislead by your reply to this series, about the alternative way of
> reading memory size from CAPA register

sure, we can do that if you prefer, I just felt I wouldn't touch
platforms I can't really test :-s

> >this has been here for almost a month, any comments ?
> >
>=20
> Do you see any performance impact with this series ?

in the normal case ? no... it helps only with large transfers

--=20
balbi

--DRfr/2Y1Zz/5r+Kb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVo9qAAoJEIaOsuA1yqRE8cYQAJX126G5hH24ybpWAVt2uUTM
wwRibxe+QnVf4fybPZptSjTum/Xb4GOia8DwzYVTOsApH1zjr3yriMOxywnqx3i4
Riija1MJAv87aoRF9EgQ/kcVn93+elflcHmJUBvYLhzMLCWxSFOLEXQf43BIUF04
boIKaG4Jng5W4T435Gtb8cM+2q6usQbJ8E+zxlHgPX4piezwC6dFm6gPuM/kn3ry
0F7wdRHQYBPtEP/T2JojveRLuEVJbzcPy0zFimnCaCMVrQqfDb47wePHaOLXn8sE
RCW2qOzVypq8D0Whynj7KRn1cUbvT6BOFTGStTvIWE+P5r8h3Yi6uSOPeq5Jvzqg
0tNKmTB4lG8PMgUwAgQeSKI8BBA6InE7ZPnEL2YULPbQGSQiqrTZ08FUv4euDL2E
2zQPDk92i+iEQAlmC9fyjH/iBT5VnfZxfp4GVcCGuJGTFq0GH0/6loUjtOLxFqDa
P+ef7WD3qb4nwzNme+dxf4AtJ9sorAthw5mz++GohvdxsvF8hi2D+rstkyCQ773g
ps6fy9m9saxkng82lL+Uu8itKvFPdvQKKm9QTaQePjoL9X9b82vBpJOKM9xb/nU9
lRX3i4bfudxTAEbuswMIbJtcDIHSoCVnlWvoQOvwBGOyqLxb8kUmKsh2SojkPmwo
92r1rSOF89MWGoRQ1wrF
=lP24
-----END PGP SIGNATURE-----

--DRfr/2Y1Zz/5r+Kb--
