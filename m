Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab3AWLYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 06:24:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42446 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737Ab3AWLYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 06:24:46 -0500
Date: Wed, 23 Jan 2013 13:24:22 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <tony@atomide.com>,
        <balbi@ti.com>, <b-cousson@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <grant.likely@secretlab.ca>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 2/4] ARM: OMAP: devices: create device for usb part of
 control module
Message-ID: <20130123112422.GF29258@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358777308-2409-1-git-send-email-kishon@ti.com>
 <1358777308-2409-3-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cpvLTH7QU4gwfq3S"
Content-Disposition: inline
In-Reply-To: <1358777308-2409-3-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cpvLTH7QU4gwfq3S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 21, 2013 at 07:38:26PM +0530, Kishon Vijay Abraham I wrote:
> A seperate driver has been added to handle the usb part of control
> module. A device for the above driver is created here, using the register
> address information to be used by the driver for powering on the PHY and
> for writing to the mailbox.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Tony ? Without this we won't have the control module driver.

--=20
balbi

--cpvLTH7QU4gwfq3S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/8hmAAoJEIaOsuA1yqREIvYP/j2I79PlB/krUKdUObwk1GJC
bZ/iM9t2xPxdjNs5DtKBow0FyEsUDIzOUVs2XsKRInuEPHgGhoJg5tdsPbnoYprQ
bX9eZshPgW39GXDQGO2KvJDFLoMI2O3O0Ud5sFmIBvFc/EwuF0JttSCYl7KvlSc8
Ul1JjptDy2BYwqdZ09ppfueKkwaHxWZX952V/k7pkV7Nsd4w8JiV7vNiXoxmmbyt
Y6arAnhZADS+qjPnRkmB8yCWPN0hmRu8eJaK1fh25fmEXiFiYvZ0J1rgq8rbfBoC
IqDbUP0Gs85XtKrwLBZlBvSt5wN0EXjPLsgZOI/gaBnpteqj+fZWqlpt0Q/JHNNN
W883S49/SjAQxQjOnXuCLr8qm5S3IaDDtNgtbB+sWxGcdd4tDGIYSvM8r9JjQ+xk
cdTtp/HQdx2rnJrgISUvW/Vsvv5P0+zV5MZYTqjzo71NGwXH+wbxFpMM+dYG6Yty
liKQjMcXrh5D5h/Of+o2pM5KnRD4CjANomVu4dq+09ZUKBlotIlbPWgg7Uabf1+j
/fPPbGOlHPozn4W3UKsf4yI9upnX84Cf+PQvCe1ouVttBWu5ynE9aTzaXD1hXIoS
d5pz3IjUe4A2qnOW4GJwFkMXXjTLmreftV+Aa85gldsIrMdDhJEv21Kdv6dDURaX
HH1B5evD0ymZkiv3Ndvw
=sCR7
-----END PGP SIGNATURE-----

--cpvLTH7QU4gwfq3S--
