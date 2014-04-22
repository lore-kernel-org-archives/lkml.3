Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbaDVP0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:26:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45418 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666AbaDVP0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:26:48 -0400
Date: Tue, 22 Apr 2014 10:24:25 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v6 01/19] usb: phy: msm: Make driver selectable on
 ARCH_QCOM
Message-ID: <20140422152425.GL5524@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
 <1398158438-21579-2-git-send-email-iivanov@mm-sol.com>
 <20140422145701.GI5524@saruman.home>
 <1398179795.4724.170.camel@iivanov-dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jB+02Y6wHc2pEa2x"
Content-Disposition: inline
In-Reply-To: <1398179795.4724.170.camel@iivanov-dev>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jB+02Y6wHc2pEa2x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2014 at 06:16:35PM +0300, Ivan T. Ivanov wrote:
>=20
> Hi,=20
>=20
> On Tue, 2014-04-22 at 09:57 -0500, Felipe Balbi wrote:
> > On Tue, Apr 22, 2014 at 12:20:20PM +0300, Ivan T. Ivanov wrote:
> > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > >=20
> > > Controller could be found on APQ and MSM platforms,
> > > make configuration description more generic.
> > >=20
> > > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > > ---
> > >  drivers/usb/phy/Kconfig | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > >=20
> > > diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> > > index 416e0c8..0c668a3 100644
> > > --- a/drivers/usb/phy/Kconfig
> > > +++ b/drivers/usb/phy/Kconfig
> > > @@ -171,11 +171,11 @@ config USB_ISP1301
> > >  	  module will be called phy-isp1301.
> > >=20
> > >  config USB_MSM_OTG
> > > -	tristate "OTG support for Qualcomm on-chip USB controller"
> > > -	depends on (USB || USB_GADGET) && ARCH_MSM
> > > +	tristate "Qualcomm on-chip USB OTG controller support"
> > > +	depends on (USB || USB_GADGET) && (ARCH_MSM || ARCH_QCOM)
> >=20
> > I would actually drop USB || USB_GADGET dependency here just make it
> > easier to enable the driver on Kconfig, other you have to enable
> > USB_SUPPORT, then enable USB, go back one menu level, go down to PHY
> > menu, and choose this driver.
> >=20
>=20
> Because phy directory already depends on USB_SUPPORT?

right

--=20
balbi

--jB+02Y6wHc2pEa2x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVompAAoJEIaOsuA1yqREt9IP/R6qpLTSqvczl15xPruBO2CG
Ry3LiUAgRxlneFkriVD6w76ynMPC8D5AjpE8IfVm2cLz4ptnUmM9KzK9VdM7nrEh
vZn9vnyVVTMT5yR2GANLV3tLPLL7pjCGfgrkLeZZaeAmw6tpyjpocihTbboL1jnz
O2lRw2mpwbIKgiYZyTlBr1lniLWxVIxS4IomBZuX8PoC7xUURYG3nbgXocx0zZSK
l3AtSRv1XTXY8LafAYBTLkaAkHyiy9iIGM7/db6eHVdD4Pu3Q4XGjO+YDkr4tzVG
On0EERM44N+NuEo0AgfAqvf8YJiR36hOnVPXZeOyP8I+nhTLe8Yf8EcAHjxzxHn6
3Nb7h4KC6kxi7wdV4FNDd8H4sEYl2py4vBdb1oj1vRzS1/bBBjZN6k0rymf6g95L
5D1nF7361L6CjHu+tB2EhjfO4opQv5iiaqcGhT4QG122moQorTAxj/wsWKqn1Kkz
h72Fappd9Myg+7k8a1icm1I/iRfKobBz6uj0yMA8t2Il6ayyKmY4ltSrDVmzGQ8E
VKdfRdJNrnisBhKXOvV/1TCDhqRRV6qd8rJYandO/IJxJTmAvebXKoNDBZd70AIX
paw0aBKupGe0jiTKbk6lpEspteoNPsOUqrAyVML709x+4zP9egJRrtPDsu41BC3w
svIvsrTf1akXgKYgHHsD
=noJ4
-----END PGP SIGNATURE-----

--jB+02Y6wHc2pEa2x--
