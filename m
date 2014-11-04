Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaKDUnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:43:17 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37932 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaKDUnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:43:15 -0500
Date: Tue, 4 Nov 2014 20:42:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Message-ID: <20141104204200.GC3815@sirena.org.uk>
References: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
 <1415090986-30623-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hRAxCRQ2NfTfhomj"
Content-Disposition: inline
In-Reply-To: <1415090986-30623-3-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/6] regulator: max77686: Initialize opmode explicitly to
 normal mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hRAxCRQ2NfTfhomj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 04, 2014 at 09:49:42AM +0100, Krzysztof Kozlowski wrote:
> Minor nit: Initialize the opmode for each regulator to normal mode in a
> readable explicit way.

Applied, thanks.

--hRAxCRQ2NfTfhomj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWToYAAoJECTWi3JdVIfQDIkH/RWLm+ys09qAU4E9rMhNjc/g
KKLY1rSbPCBffmwKDfba0CYIYLVhwRBVO+FNvBENE7AQV2+Y5G0vyPE34MCXswda
bPQm2nyinzTpdtmYrO1qFugeVthrwIA8LPouI+OAmBLZN+CQOhuLMqdqWbVRw6gm
RYHn36N1pQt4MW6JpA8dgFkguhps2E2BrudYl9BckGs/UytGhY/A4BbA/cHVfFeO
CEd061VfPiqH1wvXoKmhIYEFjJw4EDPPKVeHi9+HCrwRUbc4u40ODpsEwD6u2D8Y
7rKJHOs1vMe/tnp4zmEctSTvngvod/AODRTZQ39w8qI5y834LOJp3XRZUlxrJW4=
=ueEQ
-----END PGP SIGNATURE-----

--hRAxCRQ2NfTfhomj--
