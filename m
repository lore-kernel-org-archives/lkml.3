Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaHSVRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 17:17:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49399 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaHSVRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 17:17:42 -0400
Date: Tue, 19 Aug 2014 16:17:04 -0500
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <treding@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Xiubo Li <Li.Xiubo@freescale.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Message-ID: <20140819211704.GS24407@sirena.org.uk>
References: <1408466947-26593-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PkEWctFf+8E2rcii"
Content-Disposition: inline
In-Reply-To: <1408466947-26593-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] regmap: of_regmap_get_endian() cleanup
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PkEWctFf+8E2rcii
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2014 at 10:49:07AM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> Commit d647c199510c ("regmap: add DT endianness binding support") had
> some issues. Commit ba1b53feb8ca ("regmap: Fix DT endianess parsing
> logic") fixed the main problem. This patch fixes the other.

Applied, thanks.

--PkEWctFf+8E2rcii
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT877MAAoJELSic+t+oim9WKgP/3qsBfRRBx/ziyg4giroQ6oB
y7Y9YBq4p5Stc2TNCXQ8Npnn46zXdqc+diwkE4RI71TKZuzvbdT6Rzg4XhKY3Cp3
WAQgbvQhNgL83yd7hjyhN6pdxkKEqkNMgFSI7/z5fCK8K0LkY4sdZDGkgNJ8m3iW
cdkKzk/NI7V5m0YrXMNtQH0Q1AbUgTXyL9dDdBTPn/2Xzfx4IDCx4QX3irNDdkKJ
ZEzzXJEqfADm9lwFhCxXK8mok/MWNxQ8cT3DTQqz4pb+D49FPM4XBdwbiOUGNVRF
CJlbBtZRvsVe1Ux7xMytm4nqCaMUihmBOaQbiwrBhDUGfR86WQF71X4Za2WVhP9n
WwaCenIzitMK/NBBWNaiMylKtFdLbF7WIfMduvBbOLw+PpWXewdT03oeeW5uC5Js
AJ72dj6ZApE9LqzgZa0OmmxuOmzK8SEfcsZuel8lVpp/gN03NlRQ1ldF8BoL4T7Q
PashkkoWzRBiNXD1CnGkeURPNEfuHIuKv8aV9QarIxfFUADRNSNEZhLrTqVqEK9P
yobUtrPS+aZZ1QwWqugCaq7Y7F1jviGLJxZcN9k9U1NILYR1jYPWqM66/WR1/HmZ
bQE1TU3drErS73jfnipJzN0S1GkHNFv2vrnBZ2GBKU4mfblEkbCnRij3BF4NoK1L
GRKjckiGl8KkmddvrIYs
=qSos
-----END PGP SIGNATURE-----

--PkEWctFf+8E2rcii--
