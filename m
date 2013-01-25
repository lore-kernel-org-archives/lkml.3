Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab3AYMTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:19:37 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58386 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757295Ab3AYMTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:19:03 -0500
Date: Fri, 25 Jan 2013 14:18:38 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <b-cousson@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <s-guiriec@ti.com>, <gg@slimlogic.co.uk>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] ARM: dts: omap: add dt data for dwc3
Message-ID: <20130125121838.GC27148@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359112312-6918-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ABTtc+pdwF7KHXCz"
Content-Disposition: inline
In-Reply-To: <1359112312-6918-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ABTtc+pdwF7KHXCz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 25, 2013 at 04:41:46PM +0530, Kishon Vijay Abraham I wrote:
> This patch series adds dt data to get dwc3 working in omap5.
>=20
> Changes from v1:
> * rename "ctrl_module" to "ctrl-module" and "usb_phy" to "usb-phy"
>=20
> This patch series is developed on
> git://github.com/rrnayak/linux.git omap5-3.8-rc4-base-palmas
>=20
> This is the last series of the series of patches.
> I've kept everything in a single branch
> git://gitorious.org/linux-usb/linux-usb.git omap5-with-palmas
> (changes up to 23b4dfa2ab7052569cd88acc6383c4b1a8e8a482)
>=20
> Did enumeration testing on omap5 evm.

I have gone quickly through this series and it looks already to me:

Reviewied-by: Felipe Balbi <balbi@ti.com>

> Kishon Vijay Abraham I (6):
>   ARM: dts: omap5: Add omap control usb data
>   ARM: dts: omap5: Add ocp2scp data
>   ARM: dts: omap5: Add omap-usb3 and omap-usb2 dt data
>   ARM: dts: omap5: add dwc3 omap dt data
>   ARM: dts: omap5: add dwc3 core dt data
>   ARM: dts: palmas: update dt data for palmas-usb
>=20
>  arch/arm/boot/dts/omap5.dtsi  |   48 +++++++++++++++++++++++++++++++++++=
++++++
>  arch/arm/boot/dts/palmas.dtsi |    4 ++--
>  2 files changed, 50 insertions(+), 2 deletions(-)
>=20
> --=20
> 1.7.9.5
>=20

--=20
balbi

--ABTtc+pdwF7KHXCz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAngeAAoJEIaOsuA1yqREol0P/3akqoDidmGfhZ4q3ktajHMc
v7I77xgpLGd1XlN0iiqp4N4SgH7Ue2w4DDVeN0YYT5LS01B82nLhCM0UQ/oD1NvE
tsF+HPEPmb2piXudHx+ZMRI41XZoiTmuKjwx3Vk1N4pcI72tGzzfITgU+Mbx8cyt
+cy9BNtLBTYRhMshEAIHyKgYxLS9PmGoIP7mc8QBAtf5U2gistIaw5lz/cK8ILEG
vnFIWFcefsDCW4snUDqrbbKvkYhkBueaKqcbKS0lNx6iuNt38OMAvggDikvY57mM
J0k5nzQEJtnO+FVt9UHXl2esHPQ3FfZpXfixI+XqpvjLFmrJk5xUI4jbTdMJCH5q
hR5AX6dMSNs6eK2rPsnF+moF6D/Rql0hb3uZUVDREt9EMNrKFvUNPRgnhSFf95MK
p5YUaDIj7DuaEitmjavWle/JcqZcgfoh2GN7CA9atzI5N7cxrd3xGG63WXiM/GXI
6ko/iYhN25uHPxq4gq77RshnjpJDmX9gPwqRJyPToqnUE1Z9kTYuZB+nFDszScAc
vgkEroKqE2SacO24gefSHs56QnCmj3hwFk0syR6kguOhmXEq/1y3Gf8Pic/uissV
XQ1OsfS+Vsj4hpit+z+o/L9ZM5m5g7KEziioNUjOtAmJ9KbG8X85vGsKzsZCRBJc
qsnueGNO/NkOdZ5FXrQ8
=dCWo
-----END PGP SIGNATURE-----

--ABTtc+pdwF7KHXCz--
