Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab3GHVE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 17:04:58 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:60667 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab3GHVE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 17:04:56 -0400
Date: Mon, 8 Jul 2013 23:04:52 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, oliver@schinagl.nl,
        linux-mtd@lists.infradead.org, Wolfram Sang <wsa@the-dreams.de>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org
Subject: Re: MTD EEPROM support and driver integration
Message-ID: <20130708210452.GL11243@lukather>
References: <20130705201118.GM2959@lukather>
 <5811519.oHVuMujf0I@wuerfel>
 <20130706120112.GA11069@lukather>
 <8997501.Dchyii8uWX@wuerfel>
 <20130707071501.GD11243@lukather>
 <20130708083614.GP27646@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8/UBlNHSEJa6utmr"
Content-Disposition: inline
In-Reply-To: <20130708083614.GP27646@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8/UBlNHSEJa6utmr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 08, 2013 at 09:36:14AM +0100, Mark Brown wrote:
> On Sun, Jul 07, 2013 at 09:15:01AM +0200, Maxime Ripard wrote:
> > On Sat, Jul 06, 2013 at 09:06:49PM +0200, Arnd Bergmann wrote:
>=20
> > > We also have a bunch of OTP drivers spread around the kernel, it prob=
ably
> > > makes sense to consolidate them at the same time, at least on the DT =
binding
> > > side if not the device drivers.
>=20
> > From a quick grep, the only one I've seen so far are:
> >   - imx6q, that has a hook at machine start to poke into its OCOTP to
> >     retrieve some frequency scaling parameters it seems. I'm not sure
> >     how the current solution could improve the situation for this
> >     use-case, but the DT bindings of the OCOTP is just a DT node, with
> >     no clients, so we have nothing to worry about here.
> >   - imx28, that has a hook at machine start to look up the MAC address
> >     values and patch the ethernet controller nodes to add the right
> >     local-mac-address property. This one could benefit from the new
> >     bindings, but we already mentionned it, and I intended to develop
> >     with an imx28 board anyway.
> >   - picoxcell-pc3x3 DTSI has a node for a OTP device, but they don't
> >     seem to be doing anything with it, nor do they seem to have a driver
> >     for it. So I guess we don't care about migrating for this one
> >     either.
>=20
> > Did you have other cases in mind?
>=20
> We have some OTP support in the ab8500 and wm831x MFD drivers too but
> they just expose the data.

I guess you mean ab8100, right?

Anyway, thanks for pointing this out

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--8/UBlNHSEJa6utmr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR2yl0AAoJEBx+YmzsjxAgQhsP/1RiP1Ft/gRJR9yxekJHQ29P
FOMSNecQQwcoh4gpReIZVcKiq/OeM7CPdzTXu70ma/5E2l/WbVYjXzE6P2zPZyn9
vii7+BLp4VltgkGvKS4yEDaJE8sY0V9Eztk2WKIJaF4Rg8dBU+dfv1boH60YFzrJ
NX5Xn8D/OtTZ2oaD+jlPc3a1gEZrg3V8GV2eYMLTQFUHKDedNJwdwdHuCEGR8XTu
NKSF2It5z7ZvOkrCwveVL8nZ/ehFKJGVz7DNbj88p+XnCiZ+EOKZCbi/OZ924UwD
XAeL03obiKwWzqRe7IBsu+PK1W3BSl6CrKYHe+YAmO9jwNIeUpNjUY2WqcrNhEkq
5ZIWM9wkexm72TJZ0K3X48ysX7h9AtqJuYRHUc/bMz1bU2s8o0BwdlXL+C2CdBZl
p5SEyby2bJlZVQiIuJLzZGvH5r4AIPuz6s4d0c/O4oK9Nrq7BKIf8CFtvx0U7MXu
OuUYvyhoRdDhlaXfXgK292l+YyHO33EHN93oB99jhdRNUnVitcW2YC9fGcWgN+B6
zgSoBCBR649hzm8sNw3n24FouNGfPHrJIDpHDEy9cImolC6GeimzKEd8d9kVXw9x
VqRg68qQrcE6EM0zrsYYRG5uiHKKUpaoBglR+ibNIATfOuUQt3EZYPY4OPg8bJi6
+04FoPiWLmYI29X6IIUC
=rjWp
-----END PGP SIGNATURE-----

--8/UBlNHSEJa6utmr--
