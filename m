Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3DKKEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 06:04:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40341 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436Ab3DKKEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 06:04:44 -0400
Date: Thu, 11 Apr 2013 13:04:35 +0300
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, "Balbi, Felipe" <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] USB: ehci-omap: Select USB_PHY
Message-ID: <20130411100435.GB14394@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <5166856C.3080906@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fba/0zbH8Xs+Fj9o"
Content-Disposition: inline
In-Reply-To: <5166856C.3080906@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 11, 2013 at 12:42:04PM +0300, Roger Quadros wrote:
> Hi Greg,
>=20
> The following patch gets rid of Kbuild warnings when USB_EHCI_HCD_OMAP
> is enabled.
>=20
> Patch is based on your usb-next branch and is needed for 3.10.
>=20
> From: Roger Quadros <rogerq@ti.com>
> Date: Thu, 11 Apr 2013 12:08:19 +0300
> Subject: [PATCH] USB: ehci-omap: Select USB_PHY
>=20
> As we need NOP_USB_XCEIV which depends on USB_PHY
> we need to select USB_PHY as well.
>=20
> Gets rid of the below warnings when USB_EHCI_HCD_OMAP
> is enabled.
>=20
> warning: (USB_EHCI_HCD_OMAP) selects NOP_USB_XCEIV which has unmet direct=
 dependencies (USB_SUPPORT && USB_PHY)
> warning: (USB_EHCI_HCD_OMAP) selects NOP_USB_XCEIV which has unmet direct=
 dependencies (USB_SUPPORT && USB_PHY)
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Ideally, however, we wouldn't select any PHY in particular as different
boards might need a different PHY driver, even on OMAP ;-)

--=20
balbi

--Fba/0zbH8Xs+Fj9o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZoqzAAoJEIaOsuA1yqREIWcQAKXAy33ZCaFz0dTN9EcexjyL
mA54cLaE24Nu+jhSVTSzRdTQV2awgNfCdYAqika7cO+VGg8V+Ju2TK0Xz4r5nHML
bNSO8Dmn4Wo4soNJpPLK/uJsyDkw2SIZjtJjoV78Ol+kqhPF+Si7fv0rA44/x5mS
nerhw0rR/yY6Cwb5qekD9IQanDD0EfvfZSyGBxeHTGPS8ZN0KkXsRA4CDpg4EDpi
uDZJP9lXkCEQekTVU/t7qH3L+dDpGPBJWV9EwWNZjG/Usjt3w6coRJcoFT8syeF6
ZIGd++5kY56M8ATdDDsdZqolfZ7eFEakqlnZ6/bs6R4IFgeHXvrBUXl6lTeqPznF
yBn1n2qCo3eTEhyhWU9Rm2sg1Bl8StfrTKc1LT5sd3aIyfoTQjCW/4evVfw97ACE
MBW9IHT4WLD5zjTw48SDkqKKn0pmWWf8n+MaKpMMOlbwXnzwpCJAgz6FnJtOOh/r
t9GNpONqRtSFCpnSQ8MTMlelpRaNf+okrH1PylM2ERqRVjE9iKrF4fU4a9P5rp0g
8M72+4zs+k1UnVP8FjI7xGF/aaHdnHpBA0TwaB4tBcQXjFqXEiBTMEo+avlwt3vG
DHN7R/w+Bw03AZJ+Z8uHmmJB1SoNN9VXZCC22OEID2NCXl2JEp/XFr3VT/c6Yu6N
HEmtzE+wlcx8XW+ldBkj
=9uu7
-----END PGP SIGNATURE-----

--Fba/0zbH8Xs+Fj9o--
