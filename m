Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaBSE13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 23:27:29 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58096 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaBSE1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 23:27:24 -0500
Date: Wed, 19 Feb 2014 12:28:50 +0900
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        dmitry.torokhov@gmail.com, lgirdwood@gmail.com, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Message-ID: <20140219032850.GM2669@sirena.org.uk>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1392736948-26623-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <530386E3.2030405@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sB5q8U+2Z60V3VP3"
Content-Disposition: inline
In-Reply-To: <530386E3.2030405@metafoo.de>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.132.247
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 04/17 v2] ASoC: dapm: Add unlocked version of
 snd_soc_dapm_sync
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sB5q8U+2Z60V3VP3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 05:14:27PM +0100, Lars-Peter Clausen wrote:

> We should add lockdep_assert() to the unlocked versions to catch
> broken users, but that can be done in a follow-up patch.

Yes, and not just in these ones either - we've got the other existing
APIs that should have annotations added as well.

--sB5q8U+2Z60V3VP3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBCTnAAoJELSic+t+oim9AjkP/RlnIZ871N6fYaDW70pPpgYw
/WDGA6qWXH3xP2hakGqqOC2gCLUrjCbSzr49QJPSjybjUfJ14WXc7nfZiIM4Vbh9
TjhI3EKYMwVOjC50QuU+DzF99TODwub1fTUwGqhQt8GNMkbh0ND2L0+BN6e+ftBb
VL0d+10dvChXiRNM7IPy68KVvn1ffNbUk4JgWdWhmIGGUMwDy5zp3Qycma2FeJUw
QxsRMrSyJnE9qX0wqVRhAwIQrZXT6quUdes69J/UHkI/Ui5NC6GzIUZswwl01HyS
4tULlyD82+lvKlGTgJCx1/nLupyb8JKQPQG110WPgQ+KhyOTPWKsnVaOKaLc658i
0Fc6bKFs2Djeh9QqGcS9ywA7pw40t3Hp/CsL7EIsCXZrORQqMSAKY+ZJSa8Ye6N+
JjbgGBEAnWdGmQdGfSbvQRv48xYu/UVlLkswJY8uLjQPGtKOqkghLdmWnwrcfBoX
lM7BtS+S8tOP26T+sbu2eDV/UXCIgBglZD+LpfrM1K2OE8ii27myGv+WtdUyJSy5
2eWPRwFTUAYaEVqAvKoVO0jXOuK9SQ8edHMYaP+N/3BY/OgcDoQEt+iY/r4dG1hi
gcyNuxfxAwbjIaTt8gb1A6S9aqWWTWuIyLyvqkFkJRvTEnhQr7P2K8TejLGAjpmO
BkJXPqe8IdVETijihjt5
=65Z+
-----END PGP SIGNATURE-----

--sB5q8U+2Z60V3VP3--
