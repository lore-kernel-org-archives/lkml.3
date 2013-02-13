Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab3BMIch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 03:32:37 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48204 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932314Ab3BMIcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 03:32:35 -0500
Date: Wed, 13 Feb 2013 10:32:18 +0200
From: Felipe Balbi <balbi@ti.com>
To: <kgene@kernel.org>
CC: "'Vivek Gautam'" <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <sylvester.nawrocki@gmail.com>, <tomasz.figa@gmail.com>,
        <av.tikhomirov@samsung.com>, <dianders@chromium.org>,
        <p.paneri@samsung.com>
Subject: Re: [PATCH v5 0/2] Adding USB 3.0 DRD-phy support for exynos5250
Message-ID: <20130213083218.GA2426@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1360068256-19602-1-git-send-email-gautam.vivek@samsung.com>
 <1e3101ce09b3$b2e178c0$18a46a40$@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <1e3101ce09b3$b2e178c0$18a46a40$@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 12, 2013 at 10:31:00PM -0800, kgene@kernel.org wrote:
> Vivek Gautam wrote:
> >=20
> > Based on 'usb-next'
> >=20
> > Changes from v4:
> >  - Modifying function names and driver names to follow a common
> >    naming convention.
> >         "usb2phy" for samsung-usb2phy driver
> >         "usb3phy" for samsung-usb3phy driver
> >  - Changing file names "samsung-usb2.c" to "samsung-usb2phy.c" and,
> >    "samsung-usb3.c" to "samsung-usb3phy.c"
> >  - Removing dependencies for SAMSUNG_USB2PHY and
> > SAMSUNG_USB3PHY.
> >  - Arranging SAMSUNG_USB2PHY and SAMSUNG_USB3PHY to select
> > SAMSUNG_USBPHY,
> >    which is the usb-phy helper driver.
> >=20
> > Vivek Gautam (2):
> >   usb: phy: samsung: Common out the generic stuff
> >   usb: phy: samsung: Add PHY support for USB 3.0 controller
> >=20
> >  drivers/usb/phy/Kconfig           |   25 +-
> >  drivers/usb/phy/Makefile          |    2 +
> >  drivers/usb/phy/samsung-usb2phy.c |  511
> > ++++++++++++++++++++++++++
> >  drivers/usb/phy/samsung-usb3phy.c |  349 ++++++++++++++++++
> >  drivers/usb/phy/samsung-usbphy.c  |  717
> +------------------------------------
> >  drivers/usb/phy/samsung-usbphy.h  |  328 +++++++++++++++++
> >  6 files changed, 1219 insertions(+), 713 deletions(-)
> >  create mode 100644 drivers/usb/phy/samsung-usb2phy.c
> >  create mode 100644 drivers/usb/phy/samsung-usb3phy.c
> >  create mode 100644 drivers/usb/phy/samsung-usbphy.h
> >=20
> > --
> > 1.7.6.5
>=20
> For now, looks good to me, and if any enhancement is required, it can be
> done next time.
>=20
> Felipe, please go ahead with my ack :-)
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thank you, but it's too late for v3.9, this will have to wait until
v3.10. You will get an email once I apply these to my branch.

Cheers

--=20
balbi

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRG0+SAAoJEIaOsuA1yqREEbkP/jnl/UsvIWGiTpDgYB1vQzOq
86g1zVpzvVY6kXFJaaZc4l+XdRNLMlLcUyXE295aFzLr+0AJ04s8u815Nhp6qOZH
duX2nkb3KVex9aZMCl1/G1vMP+baxEhiVnuFNfeRkU5EKwKblg//TK9h1g5ZLw45
92a9HIdHSpFRMLIDJYErQ3I7lysKtsyOeZtNYfzQ6b3mytu0gXXi2C93sj3UFvv7
qmIztDN5UVdhcPv5WkT9HVrRw3K1C8PHHkBPjLWBRe5gulXtLWtKGAt3WNbj5CFK
CZeYqd7S1ruMPkQ+l/w0k4iGdMkF7hsXr875rm4uRp5yBuzsBPaeisW+KUncMs8P
htevKGjdCGq+wHJos+lBqh22pNrj6OziHrgPEUZKcki1srEoJ0AvhARBZjTWC6RG
FgU0Y4UWcwv87qJQILvBsnUSq8jkm0SeKYKnGJsL4Z3zbE9qFdybNpDCp4GYE93V
AtvIvRIqzY/iDpDKve92kMuMGNpVAEKhcNYfebNTAk47Hs1HMsF8JExVcvdtvZqM
UIJHmbHkT8bZhDnAtI8HAvOp+mU047RS+li0X1xaLN0BHIxqa8RBcokYZ+d3tA1Z
Kg7VPYfyO5Er9gb+vwFpvsC8OaOrudnpUULWHwHnM0y5Tu6qQsqjdi1SqQHfK6R7
Vq59U/h7qrLKyUjLt4Bn
=Wecv
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
