Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3AUI1C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 03:27:02 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37003 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab3AUI07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 03:26:59 -0500
Date: Mon, 21 Jan 2013 10:26:43 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>, <kgene.kim@samsung.com>,
        <p.paneri@samsung.com>, <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <sylvester.nawrocki@gmail.com>,
        <av.tikhomirov@samsung.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        Doug Anderson <dianders@chromium.org>, kishon <kishon@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 0/2] Adding USB 3.0 DRD-phy support for exynos5250
Message-ID: <20130121082643.GF8777@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358168377-22919-1-git-send-email-gautam.vivek@samsung.com>
 <CAFp+6iHbvwTBUSZO2EvCaeCT=g=UzubLGrmPHjKUgi9Ef7enzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oFbHfjnMgUMsrGjO"
Content-Disposition: inline
In-Reply-To: <CAFp+6iHbvwTBUSZO2EvCaeCT=g=UzubLGrmPHjKUgi9Ef7enzQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--oFbHfjnMgUMsrGjO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 21, 2013 at 12:15:10PM +0530, Vivek Gautam wrote:
> Hi Felipe,
>=20
>=20
> On Mon, Jan 14, 2013 at 6:29 PM, Vivek Gautam <gautam.vivek@samsung.com> =
wrote:
> > Changes from v2:
> >  - Renaming 'samsung-usbphy.c' driver to 'samsung-usb2.c' indicating
> >    usb 2.0 phy controller's driver for Samsung's SoCs.
> >  - Moving the register definitions and strcuture definitions to
> >    common header file 'samsung-usbphy.h' to be used across
> >    usb 2.0 and usb 3.0 phy.
> >  - Keeping common exported function definitions in samsung-usbphy.c
> >    which can be used across usb 2.0 and usb 3.0 phy.
> >  - Writting separate driver file for Samsung's USB 3.0 phy controller.
> >    and making it dependent on USB_DWC3.
> >
>=20
> Is the re-organization being done here fine as per requirements for
> separate drivers for usb 2.0 type PHY and usb 3.0 type PHY ?

should be fine ;-) If there is *truly generic* pieces, it makes sense to
re-use - unless those "generic" parts are common driver churn
(platform_driver definition, module_init(), module_exit(), etc).

--=20
balbi

--oFbHfjnMgUMsrGjO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/PvDAAoJEIaOsuA1yqREbJcQAKGcvaVboLtCXoQJuWnrfC0b
Eupv6hbk2ZQtt8hUwriSa0IFQm80T/xj2psZX2UxN+PpXyB3KPNMe6ADgvPNyb9f
EGwbhP3f7lylAaDa8lZY6yzqKHo7T/x6ufMC2vIApPxYzDyMMQJ53s3z/ZVStNNc
vJK0CEsZDrlY2ojtv0yq5RjARg+9t+ddAC/6IYZlXW5p87BYk2Ty4mgM9PvFgCR6
qGSCgOc8aHx2YwSglRogpfDPlMLdlhjaateM/35wg7BRtPnZIRO73pZsw8FrBVNX
hLnkubTlzGMGzp8fRU4z7CdRoCcR9WOQ4PHw435jCIBPB36mXsg/BeWAsWAlkAKC
wKGVJMCKaQy1/Olqjq0KAPRm9ZVzvDYIy/2/1fNPEP/DJBGk9XoAHG5WGYlVCBjm
7PJjcAAhsZtSZR2A7Htub1uCdinPqjHLE3oIbxvwn8pfR3MeJDuPu5w2FUXqLkJc
rFISQZTEkwbhF3IFlXDQ/G5CwziQDV/KIWON+JR87RskMIg4uOC2FFTbPcHKHBfl
+bo0i07EuP6reE8PkWgr+DQ0iX1DYcFoa88iN2GdvIh/+ScPv5G8qPNnkakcGOqQ
YFkFOxzaoPUOsQ8J112OquZ5An2rsHNJdNsgN3FU6mEAe3IKL9LsfZSFTkzwSLrJ
uCX4lIde+gH/0c0WQVla
=hJDy
-----END PGP SIGNATURE-----

--oFbHfjnMgUMsrGjO--
