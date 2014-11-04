Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaKDT65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:58:57 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37859 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbaKDT6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:58:54 -0500
Date: Tue, 4 Nov 2014 19:57:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Torsten Fleischer <torfl6749@gmail.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141104195732.GX3815@sirena.org.uk>
References: <1415031475-2268-1-git-send-email-torfl6749@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="umhhH1MY3lvPZrwj"
Content-Disposition: inline
In-Reply-To: <1415031475-2268-1-git-send-email-torfl6749@gmail.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/1] spi: spi-gpio: Add dt support for a single device
 with no chip select
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--umhhH1MY3lvPZrwj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2014 at 05:17:55PM +0100, Torsten Fleischer wrote:
> From: Torsten Fleischer <torfl6749@gmail.com>
>=20
> In order to describe a single slave device that has no chip select line
> the 'num-chipselects' property has to be <0> and the 'cs-gpios' property
> doesn't need to be set.

Applied, thanks.

--umhhH1MY3lvPZrwj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWS+sAAoJECTWi3JdVIfQ2zoH/AtLkp1eNCvq46l7yZU6Cy+9
DUB96pmHjF1HozvCcFPzuS9S+6JUJYxmoVYltYKt6hb5D/Pgta7z3Iwo9BTwe/pt
/bW4S7wCb2Bu2yfZ4Heu2vftWhUXc3cwfi0VPT7qsCch+EOEHH3cw3W0vFcPVq2+
YH+EG6wOHhrVWojX6YsOH/0Trl7YAsWKC1sqI/E7IKnr6C7c/KQ/KJV3FIhpIDtN
cqCVZ0YIpozGCqmAPWMCTkJlYaxXVahiXixqZ4o6OJ9K0j5khHLPhxjWK9KTJUU8
QsSiQbVLRkbFa58Xv7DB2azHpB87JaJR6aMXbyKuX04DBfg4/7HQVY0SlFdIW8U=
=nmig
-----END PGP SIGNATURE-----

--umhhH1MY3lvPZrwj--
