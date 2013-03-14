Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab3CNNdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:33:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43267 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757916Ab3CNNdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:33:20 -0400
Date: Thu, 14 Mar 2013 15:33:13 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <notasas@gmail.com>
Subject: Re: [PATCH v2 0/4] usb: musb/otg: cleanup and fixes
Message-ID: <20130314133313.GB26080@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1363242239-1061-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uQr8t48UFsdbeI+V"
Content-Disposition: inline
In-Reply-To: <1363242239-1061-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uQr8t48UFsdbeI+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 14, 2013 at 11:53:55AM +0530, Kishon Vijay Abraham I wrote:
> This series has some misc cleanup and fixes. The fix solves the cold
> plug issue in omap3 which some have reported. Developed these patches on
> fixes-for-v3.9-rc3 after applying=20
> http://www.spinics.net/lists/linux-usb/msg81563.html
> (Grazvydas Ignotas patch series)
>=20
> Tested for g_zero enumeration in pandaboard and beagleboard in both
> cold plug and hot plug case. Any kind of testing for this series is welco=
me.
>=20
> Changes from v1:
> * removed *usb: musb: omap: remove the check before calling otg_set_vbus*

it's still on your list of patches :-p

> a similar patch is already merged.
>=20
> Kishon Vijay Abraham I (4):
>   usb: musb: omap: remove the check before calling otg_set_vbus

see ^^

please fix it up and when resending add Grazvydas' Tested-by since he
has tested this patchset

--=20
balbi

--uQr8t48UFsdbeI+V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQdGZAAoJEIaOsuA1yqREtKwP/jV1+GZGRfTYgDo5dNayf3Wl
OPCsDHGCb44DO2xXX/VAAc2kXXljV3eM3Fb3esKSb2zvKMeWHzNhpnQCq6cBu41l
yeZALqfYb5B0Dz9lngaDFL8UC7WiPdiZLNva6nLNUmpv6d8Kqa+vB4rpNyO3OPGM
LsqJMOEV7cPFYO7cmtTd+yTmE8XWvdqFvBSMup7wZaeiglv2k4t8AvhaYLWjcViU
T4kPgtR60TJ2G8QTYCI8UDFxv8FimHTTc6G5dN1fwclUSjwiZNwNFTL39USsZPd/
1cv+1ZNGTfduEVDCX5CeMxcniq3eXDUktmSj4xP1GI8kEWsgvTfVlhvLnRTwXhBy
dCNLWUB42euzUKKJ5siySTNFEnn0cHue4k/JNZiGmp3aG9QgFIaFt+MgrG5hkILW
gBZ6nxH8G3nFACYJpkMFRIMrAhPNgn3XwsFu9sBSuAfUX4no5T2qpmOOfsiarjcH
I5jlAInQSUMMMiYWag5hWlUBEJdPYJJqoLZckq03r+oZ9cU8u/Oxu0qHgtQ2V+c5
401qOcjTV7S15YfqG7HT6Hry3q1Tf70buduBFN2vHGx4CwjIclNhi4Gu/7mu2YMY
oqZVUpX7l7qnY+Mr/wa2nYDAhW2nm0HDa6ZoQeh2j+bEEN/JIaKi35Y9Ywaf0HDv
Jb2k7s8gXlKHeT9m1LaI
=HRL4
-----END PGP SIGNATURE-----

--uQr8t48UFsdbeI+V--
