Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563Ab3DEK2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:28:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55552 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754630Ab3DEK2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:28:51 -0400
Date: Fri, 5 Apr 2013 11:28:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, dp@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/1] regmap: cache: Make regcache_sync_block_raw static
Message-ID: <20130405102837.GJ6597@opensource.wolfsonmicro.com>
References: <1365066378-3384-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3bvv0EcKsvvYeex"
Content-Disposition: inline
In-Reply-To: <1365066378-3384-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3bvv0EcKsvvYeex
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 04, 2013 at 02:36:18PM +0530, Sachin Kamat wrote:
> regcache_sync_block_raw is used only in this file. Hence make it static.
> Silences the following warning:
> drivers/base/regmap/regcache.c:608:5: warning:
> symbol 'regcache_sync_block_raw' was not declared. Should it be static?

Applied, thanks.

--u3bvv0EcKsvvYeex
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXqdHAAoJELSic+t+oim9q64P/RQvSMGZA+okhCCsUQFY488Y
h5466BUr5JN6wvJtFP0o8aziWtS4xuh+SsN4+UCG8Vd4xH/UO3iCi3RLyvEJVSi0
4KcLbHCPSVenfCNrsgaOghX7sJlqH2lUSyXJhcgK76u6dJPpDFKYjjXtBBhKpN5B
HTkTwaE5BjtjEXLuPHJtz56cQBHC3+4HPz4Rh0WaBQXqYnODCzNnTKv9lYzmyTmE
haHFXN+BbHsKesZYtGg2iHC4TLTdg1zkbcqw0YV6rWsS1rWByaiLgn36DM0kPh8x
flUhpY7MfiaOo6YOSgMxzzEopexy7sLRgJNiOvowjiuqSs5k57iTiYyhOU73n5Qg
7p6KX6zmk+zgLNAWlGBmJHyXR2e01deNFo6U3v3Ix9gPyswyFuFVob1K0eqGLbmY
vpaG+vghTlLJnNbQ6H+PLsUqGFPCR5WyudrJOOka1vcz8ynlFK/dupuJcxVmeSzu
LttD6orA0xmUXlpI/oe6IIpF8rNU4u/BwqExfjcseFw/UBMToANNt5WGy0MMG1HN
8Z2sISrucPBPWSFf+UIzo3A6pyNzIlZMBKX4hX6TiGbIfmivRB62exVwwQWsYZOG
ptZ4kDIRO5HpsZw896ZBu28VjAYFsBt6xF2R2im5B1heqXv595ChjhCVcCB5cO9M
kozibpUhLFcYEHG7tAhT
=MaqT
-----END PGP SIGNATURE-----

--u3bvv0EcKsvvYeex--
