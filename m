Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab3CTP7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:59:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51480 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab3CTP7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:59:45 -0400
Date: Wed, 20 Mar 2013 17:59:27 +0200
From: Felipe Balbi <balbi@ti.com>
To: kishon <kishon@ti.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <notasas@gmail.com>
Subject: Re: [PATCH 0/5] usb: musb/otg: cleanup and fixes
Message-ID: <20130320155927.GH1567@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1363164430-19118-1-git-send-email-kishon@ti.com>
 <20130320131240.GA15157@arwen.pp.htv.fi>
 <5149D43C.3060506@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RwGu8mu1E+uYXPWP"
Content-Disposition: inline
In-Reply-To: <5149D43C.3060506@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RwGu8mu1E+uYXPWP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 20, 2013 at 08:52:36PM +0530, kishon wrote:
> Felipe,
>=20
> On Wednesday 20 March 2013 06:42 PM, Felipe Balbi wrote:
> >On Wed, Mar 13, 2013 at 02:17:05PM +0530, Kishon Vijay Abraham I wrote:
> >>This series has some misc cleanup and fixes. The fix solves the cold
> >>plug issue in omap3 which some have reported. Developed these patches on
> >>Linux 3.9-rc2 after applying http://www.spinics.net/lists/linux-usb/msg=
81563.html
> >>(Grazvydas Ignotas patch series)
> >>
> >>Tested for g_zero enumeration in pandaboard and beagleboard in both
> >>cold plug and hot plug case. Any kind of testing for this series is wel=
come.
> >>
> >>Kishon Vijay Abraham I (5):
> >>   usb: musb: omap: remove the check before calling otg_set_vbus
> >>   usb: musb: omap: always glue have the correct vbus/id status
> >>   usb: otg: twl4030: use devres API for regulator get and request irq
> >>   usb: musb: omap: add usb_phy_init in omap2430_musb_init
> >>   usb: otg: twl4030: fix cold plug on OMAP3
> >>
> >>  drivers/usb/musb/omap2430.c   |   22 ++++++++++------------
> >>  drivers/usb/otg/twl4030-usb.c |   35 ++++++++++++--------------------=
---
> >>  2 files changed, 22 insertions(+), 35 deletions(-)
> >
> >this needs to be rebased against my 'next' branch.
>=20
> The v2 of this series is already in your testing branch. You still
> want it to be rebased to your 'next' branch?

sorry, no need. I just forgot to mark this one as read. My bad.

--=20
balbi

--RwGu8mu1E+uYXPWP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRSdzfAAoJEIaOsuA1yqREnJEP/1fAgfyG2v8+qK5MbitQkt4A
vGbFqhSr5T4QNXA5Af1W1BVCN4xt0loOvUBFPhZGymUe+cuxDYNauIE4F05kdKce
ZxJfE6AgTwwgLxphixAVhw4DMYZXY+peNgeFt38cIHjDAJUgvYI9imp0xUbquCSx
IMk2aDof6CVRm+CaN0yZXYm88gWC+wCUjl5vfn469+wPBBU2uox+lvdONAAJqJHq
7mLw3GSB8JUpKjiU0g3EHM+IwR087xYnhWBVKTGEK411uF0vbNVrxu3CGnB9iRgt
IuLDZ6Oo0hYKV73jfu83T2uUhiAozVjEGzr7PiHpWzNacACnRvF+WYqS9BAZcGZi
IqSaK5QufsnY2Ixpa48d1tTvz32FDvXceSn8a7eItbyfqaYUfwm6U7zYuWZI/oFp
2Bm9L3us2R7nwbsJrulxJGPtloU40h5ufT02T0ZjvT8Jrkr5SkR0zEV66GEtSk/K
qd7YX8U28dMluITfJKYx2jukVoOBs/YWTyLaXAdoTpnQD4/gwWYH0liKNuO+g2Ge
MgVKm79MAJFyjK7nz7W/iqZS/yEFkFHmtnMWTD6g2Szvs9NR3E58wGKsX9HbSf7j
7Ctxz/h5BId9QoWv8ghUMlK5urIu0iIw8C+7e1Flys4uzJEtoFPsJ81QmK4u2sYn
mCq6wkYpkpCx6x/AYuzG
=nxDq
-----END PGP SIGNATURE-----

--RwGu8mu1E+uYXPWP--
