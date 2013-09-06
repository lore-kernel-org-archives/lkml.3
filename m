Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab3IFPlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:41:24 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50277 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab3IFPlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:41:22 -0400
Date: Fri, 6 Sep 2013 16:40:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130906154059.GI29403@sirena.org.uk>
References: <1378479340-31237-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgApRN/oydYDdnYz"
Content-Disposition: inline
In-Reply-To: <1378479340-31237-1-git-send-email-geert@linux-m68k.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/drivers: Restrict COMPILE_TEST by HAS_DMA where
 needed
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgApRN/oydYDdnYz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 06, 2013 at 04:55:40PM +0200, Geert Uytterhoeven wrote:
> commit dd1053a93fdc11d491f5460f7da5ce70e6c93c9e ("spi/drivers: Enable build
> of drivers with COMPILE_TEST") allows compile-testing drivers on platforms
> they're not meant for.

> However, adding "|| COMPILE_TEST" bypasses all other implicit dependencies
> assumed by the platform dependencies before, like HAS_DMA.

> If NO_DMA=y:

Why is the fix for this not to have the DMA APIs provide shims (or
whatever platforms are affected implement the DMA API)?

--OgApRN/oydYDdnYz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSKfeIAAoJELSic+t+oim97BkP/R1oFh9pIrK2WzQoFXFj6ePD
y+kD45POPfl8tTtY195s4ZVjwR63Sl3ZsvSl2uABEHM0UVaTwq/uUs3DGGEm50Db
+SIt7cF4hP4QWhM3bQriZ0UHlvdIp2DpjFpSR/uusTPhMM0yc+uiWJTpqmvopebo
0wiPjSRUZcsladbiCkZPtK2KQT0rBQvSqhmMWL0s2xQVN6MDm4Ak/NH/3icdeCtC
7W2OY8gkg2PBn86BeIfZOcrbW4xDDJSNL2QEQpGdqF44authkn/EozTnqt4+a3QO
uBAJMNFBaPeqi1euub+XauNQAnag4ExmuWz8tcqLTP+Sc+rcM1zpo75loTRwKoL2
U1Oj34iICcH1mAW05HO5qLNwRysLiwhfKUaXHs0LKbQzP1a2+ltj+6KXVjivJDxR
DJLu30iqB9awy4wTMZ+NCV2IgHBsiv8HvXrI/Zs8G6qoWk4VAHkoVey8fhLRBmhd
gKAALZzsvOtAnIns+rRqt93bj4N8wx0T2JramyzeoU604vgRRWBaEqx8JaQA9Mth
xW1L0uKYEuJa3IhlJCTBj3ceFBFkztHlKIqs9Je8iIzN+bmvDxeySb7X3a3OTXAx
YLtrmNUBf9YoqGbBiIjSlG+Wfw96bGhNvwrZempEpXyxXR1zGRzXtDvMPPV2g6HH
UAk2dy3lbjoUOWoZEIWd
=sv6q
-----END PGP SIGNATURE-----

--OgApRN/oydYDdnYz--
