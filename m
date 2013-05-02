Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434Ab3EBPnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:43:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36795 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab3EBPnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:43:08 -0400
Message-ID: <5182896F.90807@ti.com>
Date: Thu, 2 May 2013 18:42:39 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH, RFC 08/22] OMAPDSS: DPI needs DSI
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <1367507786-505303-9-git-send-email-arnd@arndb.de>
In-Reply-To: <1367507786-505303-9-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="----enig2HESBXFWEBCESDHHOUHXO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2HESBXFWEBCESDHHOUHXO
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On 05/02/2013 06:16 PM, Arnd Bergmann wrote:
> The dpi.c file cannot be build correctly when the dsi.c file is
> disabled in Kconfig. This clarifies the dependency in Kconfig
> to avoid build errors:
>=20
> drivers/video/omap2/dss/dpi.c: In function 'dpi_calc_pll_cb':
> drivers/video/omap2/dss/dpi.c:181:2: error: implicit declaration of fun=
ction 'dsi_hsdiv_calc' [-Werror=3Dimplicit-function-declaration]
> drivers/video/omap2/dss/dpi.c: In function 'dpi_dsi_clk_calc':
> drivers/video/omap2/dss/dpi.c:201:2: error: implicit declaration of fun=
ction 'dsi_get_pll_clkin' [-Werror=3Dimplicit-function-declaration]

I've sent a patch for this to DRM maintainer, hopefully merged soon.

 Tomi



------enig2HESBXFWEBCESDHHOUHXO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRgolvAAoJEPo9qoy8lh71CwMP/3qFvzGq6i+O+9Ye6uUgIteN
eQYxChsRkTIVQcrgnVS+GCEhWvPDsTtNUqTgfLtHA/Jwftm0ucd1lpOs7HPq1o8o
D0RSjri8mymWWwIFfeJcMKJL2rTTNfONf9CPeHdYoQlEYoOXT1Ld9vd6fTW02MHs
JogFm9Ese6Ho5bTbehne70OPhz9pfLhc7mWSKAdYT5Fi+I8VfxCYteHwe1dxAVZw
n5il/U/xzvnq8dgDT4i4rRLDsBkDbAgRi6Ayhp0EsISUS90Axhvrm1fhnO2hwGmT
wCXhdlOVg9SHlmrtZTKZMX1Xcz5nRVckHeq6IRh+uMGMuRo3GkwHftzWrJIg3rPs
Y4haiLsPEvGSXL8b2M4AbLAiCu4ADZJjVtYtcstyN3mWGZC5FSWhXRozNCGWImsp
Ml/etVW4Hwg5JbnBN+Wcob/Esh/LbaeOX4MFJz683Q5ISeah4nwNLmvOMXOGeRAQ
xbcUOCO/LXt8TNW7ibNyFatqyVX03QpBfqOxW/SOWzzSsxhfwAz/NscR467guFfI
b+wu8zhmVai/jz5ayil8fx2v/9+t38VOeRFoOMZxVkV3igFFQHSYrZPY9dWbBLL7
SZC0PgqfCBAX+6la5/LitzzirAY5JlasED2cRt2zRwsDCES8NCfvhj/i3g2LZ2PI
TZczB+3nlG4Q6KAQkyZF
=m6wk
-----END PGP SIGNATURE-----

------enig2HESBXFWEBCESDHHOUHXO--
