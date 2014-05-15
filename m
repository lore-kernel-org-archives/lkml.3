Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaEOHxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:53:11 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:64993 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbaEOHxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:53:09 -0400
Date: Thu, 15 May 2014 09:51:03 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: stefan@agner.ch
Cc: swarren@wwwdotorg.org, linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, marcel@ziswiler.com,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH v2 2/3] drm/panel: add support for EDT panels
Message-ID: <20140515075102.GE5952@ulmo>
References: <cover.1400103181.git.stefan@agner.ch>
 <35c081171a3d9a9401767601c02a12e266b37dd0.1400103181.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cYtjc4pxslFTELvY"
Content-Disposition: inline
In-Reply-To: <35c081171a3d9a9401767601c02a12e266b37dd0.1400103181.git.stefan@agner.ch>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cYtjc4pxslFTELvY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 11:45:57PM +0200, stefan@agner.ch wrote:
> From: Stefan Agner <stefan@agner.ch>
>=20
> This panels are sold by Toradex for Colibri T20/T30 and Apalis T30
> evaluation kits.
>=20
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Panel patches should go to the dri-devel mailing list as well.

Also a patch was posted only yesterday for a panel that seems to be the
exact same one as this, even though the name differs minimally, see:

	https://patchwork.kernel.org/patch/4175251/

Adding Philipp on Cc so you guys can work together whether this is
indeed the same panel. The only differences seem to be in the vertical
front and back porches, but I suspect that either settings will work on
both Tegra and i.MX.

Thierry

--cYtjc4pxslFTELvY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTdHHmAAoJEN0jrNd/PrOhGCAP/R2vqQQBK9P95sdbUrYUKbV/
7zG0BK4uqAZQNbVbtjPdlSOsDfHFoD0aEMZ0QzdiN2D2N4Pcgs+p0RwJgylu9Iqd
5HzwmVpvyBl4bj/XVnZQqRGUqB2x7TKhQSGdLfSC9OpD3htl+Cqp+fsw13nXq8Uz
YP/9ZzoJx1kCRTviShgVT0UvjPIsxwcr7CPaCaSzwB1iCgMtAEY/BmMp65J1yxZ7
BJC8i70zksUS+lQzs8fHeDuVcUkzDK3aeh9zImyepeARG7YaNGiDA8OLg6ZorS8i
SOsG3OmLH9j8WJTsfUML1vI1GtdS8gnJhvkO+kNhslCSwnTUdgOJB494JfsOz1In
k/PsZCSx3Lt2XRTpzOY8F80yK3VwHisw6FnTJuyZzSSymGODOax6Dg5t9+x/TN3i
Gp7MsLv9DQyBDLljxZAlvzQlrAIkZkD2maTRN0MRFdSOuOZ7GpeRY6cDpFqeRSwi
f3PuSjNXk4UK0wTXnK1UzYgNvRdMhmvn47SFsQdXAFX1C+XcjEPxmsqR4FGzeD7o
d5zDT8RcIuS7DX4kFp0+vDbtUFBygXmTgRlyvqtdrUJ0iyDu+sHS/2tQo3StcnwM
rK7q1eAXyiZnId8NQtX8JHeBHEHpwSei3O2trZ2L722i/gO7nsTDa9MFTMSrs7+U
xtxQr5Pp0Ja/81PFA3EI
=6lzO
-----END PGP SIGNATURE-----

--cYtjc4pxslFTELvY--
