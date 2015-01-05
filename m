Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbbAEULd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 15:11:33 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36741 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbbAEULb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 15:11:31 -0500
Date: Mon, 5 Jan 2015 20:11:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20150105201117.GJ2634@sirena.org.uk>
References: <1420448659-9636-1-git-send-email-k.kozlowski@samsung.com>
 <1420448748-9810-1-git-send-email-k.kozlowski@samsung.com>
 <1420448748-9810-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I/5syFLg1Ed7r+1G"
Content-Disposition: inline
In-Reply-To: <1420448748-9810-2-git-send-email-k.kozlowski@samsung.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] regulator: tps65023: Constify struct regmap_config
 and regulator_ops
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--I/5syFLg1Ed7r+1G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 05, 2015 at 10:05:48AM +0100, Krzysztof Kozlowski wrote:
> The regmap_config struct may be const because it is not modified by
> the driver and regmap_init() accepts pointer to const. Make struct
> regulator_ops const as well.

Applied, thanks.

--I/5syFLg1Ed7r+1G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqu/kAAoJECTWi3JdVIfQZc0H/Rp6UIFehbFsKipjnkNT2Xo2
8i+Wq5D59vbOkGrPiGVhxjN5EFXrWGtnTfa6HfbIJjp81xdzQqzRqtxnSa/o5ygF
+yEmH4/GKyyKHSifkgydFqBPaNmXBUEHyzfGPShvGEqyJOAoe5W3aN/oBffA2Jhz
maJVIAc2UlNjD2iU+5jJddRR1N45e/TV7slzbKnThFWVfKnzMoFhFWfYRNtgQqye
sn7w5W10jC1q7R6/lPZC46QN6WkbaioLTVraRaf3HKFLvzJiInvhZmrAv56vaiYi
WvrZ53zyzcvRVTSQ8c5L64li77r4i3Al06/7OBfrf1N1w1mUGOSy0mlrHiaAoNE=
=qI0e
-----END PGP SIGNATURE-----

--I/5syFLg1Ed7r+1G--
