Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945951AbaD3Q1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:27:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33180 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945933AbaD3Q1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:27:18 -0400
Date: Wed, 30 Apr 2014 11:27:05 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Felipe Balbi <balbi@ti.com>, Tim Bird <tbird20d@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, Tim Bird <tim.bird@sonymobile.com>
Subject: Re: [PATCH v7 16/20] usb: phy: msm: Fix PTS definitions for MSM USB
 controller
Message-ID: <20140430162705.GL23679@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398354495-20782-1-git-send-email-iivanov@mm-sol.com>
 <1398354495-20782-17-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qyHYMwAXsHLOQihY"
Content-Disposition: inline
In-Reply-To: <1398354495-20782-17-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qyHYMwAXsHLOQihY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2014 at 06:48:11PM +0300, Ivan T. Ivanov wrote:
> From: Tim Bird <tbird20d@gmail.com>
>=20
> Fix the value used for Parallel Transceiver Select (PTS) for the MSM USB
> controller.  This is a standard chipidea PORTSC definition, where
> a PHY_TYPE of 10b (<<30) is ULPI and 11b (<<30) is SERIAL.
> Fix the definitions and use them correctly in the driver code.
>=20
> Signed-off-by: Tim Bird <tim.bird@sonymobile.com>

since you're the one sending the patch, you must add your signed-off-by
too. If you reply with your SoB I'll add to proper patches.

--=20
balbi

--qyHYMwAXsHLOQihY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYSRZAAoJEIaOsuA1yqREmvIP/j/XdmRog559cRY1zI6dzIWS
DyJztzVrQnbQR2rTsXyW0F1YA1X1aXUfn3/mahMwNEifQ5eFBX53L+UFZUy2lJl5
iXt3zxRCevCHHaSAJRmmz3wcd/Y9C3BRSc+xj5gEU9SNJzwsSra7Rg4pDowjb17X
WQWRp/g1ddPIPVr3ymDSOSxehikCr00ISrFF+CRfztDvZ/Cbm5evSholCAGr+GBp
CSVxS/lVvOtaMv8qWiimsAztCa/fXYhs38FWK5LqmA7qlwdKi0qk3QU7o7LOLXoB
v33ruF2YAtiP0fjYTAT0mfjg9GLYP7D/E0UYRw0lflkdO4wgWOwcL9F2Az0g21Z5
1VQk0/TA+NOml30GlLp8d2wzJqL1mx7dBM6KbuV+CFukT4atNJ6e8ZT/Pn5tEmc3
F1Rk2zJaD/ZYvfTsvcy9Bk4PehzRZUFJfUz/OwA5xENSXcnZwrszG2gq1oEQw7Dr
IwjLpy8kClXoLRyOF8IHdCF12aeuR8l/R+BNb7szC3u6AaRxA6wzhQ4c9/tZRmEj
ZBGlwKmYRT+djNiS66BHIz980yRItEHL5sEiemLJq8mZqEEJK9ONRh3mdiDpcUjF
wMpS5pqnsAZDMBYB7ze6whCIWLEpvFjv8Xmw3Njf9YsKNdap1Idcklkkryib1f2t
zZ8j7bXSQRiTHIDaV8gi
=YXuP
-----END PGP SIGNATURE-----

--qyHYMwAXsHLOQihY--
