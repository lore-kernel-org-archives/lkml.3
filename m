Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbaKSKuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:50:06 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52936 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaKSKuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:50:04 -0500
Date: Wed, 19 Nov 2014 10:49:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141119104950.GB22111@sirena.org.uk>
References: <1416336354-32148-1-git-send-email-lars@metafoo.de>
 <1416336354-32148-4-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q1SX3yAxAkj1z+aD"
Content-Disposition: inline
In-Reply-To: <1416336354-32148-4-git-send-email-lars@metafoo.de>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.164.121
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] ASoC: ad1980: Convert to regmap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--q1SX3yAxAkj1z+aD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 18, 2014 at 07:45:53PM +0100, Lars-Peter Clausen wrote:
> This patch converts the ad1980 driver to use regmap for its IO.

Applied, thanks.

--q1SX3yAxAkj1z+aD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUbHXNAAoJECTWi3JdVIfQuyYH/RPLqibyWKLncNkp+xg88z/9
lqcQLJUNwYU+vwK/vX7R7khC1ZPYgN8OU1VaalDSHaLQRMOwBS/ROkXAvnbCYuiQ
8u3GgaGkv3lsxWbWp5d3J1BgHrL4j24zqxYp1wcdoQSqu7K7ty8AqEjZeCvzUl7Q
YzwdjOydS3e876QVVEAdZlhVsCA6vv0+H9GSy0yIpXQ4jEkGV1Gcu5pUjOkE6cgk
m5cf+pyRqkZuI1apfWz/9rMuKQbsQkGHTKSttCaA9lkNpvx9pRaCXIx4+GsBRLnJ
61/StGqO8wo6zPy0Jo3wWITvlEnHqU4LjaFKIu6HPcReuXqAwgFFEFif9oDamd8=
=/yKX
-----END PGP SIGNATURE-----

--q1SX3yAxAkj1z+aD--
