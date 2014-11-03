Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaKCPnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:43:35 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35599 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbaKCPnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:43:23 -0500
Date: Mon, 3 Nov 2014 15:41:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141103154152.GR3815@sirena.org.uk>
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
 <1415025649-8119-6-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o0y1lerN6xYE2ROn"
Content-Disposition: inline
In-Reply-To: <1415025649-8119-6-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 05/14] regulator: max1586: zero-initialize regulator
 match table array
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o0y1lerN6xYE2ROn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 03, 2014 at 03:40:40PM +0100, Javier Martinez Canillas wrote:
> The struct of_regulator_match rmatch[] is declared as a non-static local
> variable so the structure members are not auto-initialized.

Applied, thanks.

This is a bug fix not *that* closely related to the rest of the series,
if it's being included in a series like this it should've been at the
start of the series not after substantial new feature additions so that
the fixes don't get ignored due to problems with the features and so
that the fixes can be sent to Linus without dependencies.

--o0y1lerN6xYE2ROn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUV6I/AAoJECTWi3JdVIfQJ0IIAIHqG7kuJ6lvbDi2lS3KPIed
JEdqyWyZ54mYsNJXbqWWq9rgsvgvz4uiifwAkBGP0JWdVRDXmLEaeO2QiucfEhxi
LeXiK+8oP5ehuGVA1UNWbAtPXr0wahJe5R+T0qrXGbG1avhH5UHaQiPUzJUiCrC3
6od/64G4ffyWlDwT2CgmoW6ay86B+omP90jGJgYnwrd+hwRXHlbbbjeB+hyDWWU/
04+FlE6h5DGe2D0PnV0KnPevkVIIP1LyWpRBPLLyCSAqXPzPWm3w6HKe6/z+9oDC
p3LN7+uHZ2au6CVlJU8DbHb92B/PkMUym8r+bFRJI0dgCRS6Bhz/vdNIj6BdoYk=
=7TUq
-----END PGP SIGNATURE-----

--o0y1lerN6xYE2ROn--
