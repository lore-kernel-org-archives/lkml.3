Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbaLVRwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 12:52:30 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44211 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbaLVRw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 12:52:29 -0500
Date: Mon, 22 Dec 2014 17:52:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Sifan Naeem <sifan.naeem@imgtec.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141222175214.GD17800@sirena.org.uk>
References: <1418763946-22260-1-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e3HNah56eoWqGn2Q"
Content-Disposition: inline
In-Reply-To: <1418763946-22260-1-git-send-email-abrestic@chromium.org>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] spi: img-spfi: Enable controller before starting TX
 DMA
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e3HNah56eoWqGn2Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 16, 2014 at 01:05:44PM -0800, Andrew Bresticker wrote:
> It is recommended that the SPFI controller be enabled (i.e. setting
> SPFI_EN in SPFI_CONTROL) before TX DMA begins.

Applied, thanks.

--e3HNah56eoWqGn2Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmFpNAAoJECTWi3JdVIfQpusH/i4sUY5Tuaso6UIlei53YfGt
3JVfP+XfRGc2exeJNrq2pgNdFhuAOIYQ/C4ArOAgiscx4Qv8IKUWTJ3MclkPrG75
vfUoW8sYbs18PBjVWuJOdaD15hT1Wio1FNOEP8v+29KqccJBzTglzT6LFwT2ahRg
JOO68e6rfxEwRXk+gm6Op57UicuTd01btUsMlBenG6dbPHt+ESvQivGLPyNvOy25
cm1p2vndQxYqFVIWNzE6uEmjwSm04raaDinykBaTHsdf4wXYjVxgSFPitcnifwN3
TjQfgqYQlSgCCjzYLiMH2smyUUsASm8mDPQebRiUjwSohjcNORNTumisK8Ozf9E=
=ubZt
-----END PGP SIGNATURE-----

--e3HNah56eoWqGn2Q--
