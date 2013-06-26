Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab3FZPQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:16:51 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:49063 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3FZPQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:16:49 -0400
Date: Wed, 26 Jun 2013 17:16:47 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        jimwall@q.com, brian@crystalfontz.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: mxs: Simplify detection of CrystalFontz boards
Message-ID: <20130626151647.GF5803@lukather>
References: <1372258347-18422-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1372258347-18422-2-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vA66WO2vHvL/CRSR"
Content-Disposition: inline
In-Reply-To: <1372258347-18422-2-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vA66WO2vHvL/CRSR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2013 at 04:52:25PM +0200, Alexandre Belloni wrote:
> As all CrystalFontz boards are compatible with "crystalfontz,cfa10036", m=
ake it
> easier to add future boards.
>=20
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--vA66WO2vHvL/CRSR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRywXfAAoJEBx+YmzsjxAgH50P/2CrOU2Vi2CKrRDr02IZOGDU
QHLd0YZTttqThNrsWYNqjCQ0gG593/tFu5RFX8T31IGsH0YyxlC0dfmHe10YyDNe
LuCe0T3zYnTiaJd1elOSeldscUYzflH8AMV3LzGB4SbfmKOnVkr2nxyEcY197Mds
0XFB9clgRREALnHVPqRUphd4yQDf9+S1g6MlyXySRv9p7WP3VdbiPTEjs7wY9Oik
PyHsubNQuYr5xPrhyEtLOUvtgSfMx3ppA9BgmQRxpzpaRd68EV02qjYcCnfI0+wF
FOBGWfUS0EgycWjCHPPH4hUkgvxu555ZzZg0yMwTNtmXt/nZsEe6JAb6sDKExam7
chTSj07vKMQTew66TYM7/ykzfGUTLZbMgBmLbGuanlUHQqELFJnKNkAmR3VCR6Q4
RpkltNIqkiHoSj9QKC4tEIjBet5j77r2moAB0qJPDzfjxBEa03i0DUivTafu4GZu
PkIS5g6Cbol8lkt7gP6P1nHRe4dq1E7eHdOe5GKoP0FKqoPObyOpvmND0KSVOH/i
E7AoGL3d3aYp+/3lYSwl2P60cGTtmpsP0/E1Z/u3ex70YOu7/+ieJ2dJgeo1Ko7O
eBXGhDDFMuZNXyLuyZyxLrSge0h9hSJ5trFpwzaDeNqcK/dWB/mcy1buBvB1VyL1
I6OTRPsAq/vN6SZIxAZA
=wewf
-----END PGP SIGNATURE-----

--vA66WO2vHvL/CRSR--
