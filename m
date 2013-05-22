Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab3EVP6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 11:58:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57409 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab3EVP6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 11:58:35 -0400
Date: Wed, 22 May 2013 10:58:16 -0500
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <20130522155816.GL1627@sirena.org.uk>
References: <1369190195-14598-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uvMug2t/eFzFwVce"
Content-Disposition: inline
In-Reply-To: <1369190195-14598-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi: introduce macros to set bits_per_word_mask
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uvMug2t/eFzFwVce
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 21, 2013 at 08:36:34PM -0600, Stephen Warren wrote:
> Introduce two macros to make setting up spi_master.bits_per_word_mask
> easier, and avoid mistakes like writing BIT(n) instead of BIT(n - 1).

Applied, thanks.

--uvMug2t/eFzFwVce
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRnOsVAAoJELSic+t+oim9sPgP/07LLCxJyEyfMeKKq09X/JAW
KSVFdFh0PrXpICvXDbF1tTq0Nql0IXCe9+YPWNQNaxDQbj9NcY16J6XCn1XlMYuL
rPu4wUMAe0NQ8hO5Wu4DHX0T6p8BEaNQdkcLElYA5eZZSbbuRF8E4/o4EN9QjCAR
L7Y5jtJOuBDsWjrQ6Fc0ttZUDaHPvt0/HlC2OAfgA51h3FNMp7EwaCR1t4oD8uu4
F3nBxkVDmpWMeEseipaqI088WY4orkdbtPQ+Isy6YDh5ADTf+necy4ICvrqyPXub
Jla+1ziiMaccNygO0FV415mhUYbPruHd2GOHS6sDDX+Ccoykb9EPJim3de9x0u9l
UmRYwYGAOAMjR6PiE93jUNFdur73IXHKvbJYvXSyplhT2AuO8tIoFz/6YwoLqu6B
sX0/gNj5raMrukElE1ny6QVvW0UPp4OyR/WvndqVJrVSDNVmxJBv0M/NnyxYSB6S
nV3BW/OvaD4AqZZRX3fisjp/cURQT4sXAY50MrzRYVxdQe5F8l4bsbse5u/bogHL
gxGqXsWwB1nW6D55jG0Oe1jj/OVm8nxf/676Qx0jy8Poqs2hhjFJ5Wx6FxSDNzKj
6kFg+f7IWY51YrM0OpGNkeBTZYC/dlVF2B7i9yLbOyR25xqfmqRaXyTBGDCgvifF
3oo5/kSHglTgvVw2qEfG
=9Ljz
-----END PGP SIGNATURE-----

--uvMug2t/eFzFwVce--
