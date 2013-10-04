Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab3JDQly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:41:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60627 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3JDQlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:41:52 -0400
Date: Fri, 4 Oct 2013 17:41:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: mturquette@linaro.org, mark.rutland@arm.com, devicetree@vger.kernel.org,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, rob@landley.net, grant.likely@linaro.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20131004164139.GR27287@sirena.org.uk>
References: <1380803407-15196-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mFWIsQnH1d6uRhsN"
Content-Disposition: inline
In-Reply-To: <1380803407-15196-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] clk: palmas: add clock driver for palmas
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mFWIsQnH1d6uRhsN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 03, 2013 at 06:00:07PM +0530, Laxman Dewangan wrote:

> +	Optional subnode properties:
> +	ti,clock-boot-enable: Enable clock at the time of booting.

Shouldn't this be a generic clock subsystem thing?  It seems like
something that might be desired for nearly any clock.

--mFWIsQnH1d6uRhsN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTu+/AAoJELSic+t+oim9az0P/20MerOyWxGDPAZfT30L2CyO
B4iLKyxbxfZ8q3lodmC9jRVCysbCRHbKBXRn/DGYOeK+ig/3lv8Persc79uKWI8s
G4TvJiXuQpVwQRyXnjUpW/bCGu7h2Syesv1Q0Joxa3MhegQyGVG7YNfkKxHaISzF
MS2P8LLumzkYEaJnZs4o4k9dqmsPZdzgKextmYVzXMfQFT49Uv91sHdjxbfiXNZf
wU/oeb4F7Ieko4+FPwyJfPIeUeVGpnMzmB++jkIl2bw5qpHRfCLB6WxBbppjV/G6
5Ic37Cj3LLeZECE3Ap9YRuCgteqOn61c2jcBf4vGj0xWp2uLcoCt8J+WyMSSMLJ+
WX1siXg1myLLDXePnosGdCryv7xG8SbNEN9yffwOcgtCUHL3jfBAS03wrqC438HX
xgli7O48w2SidYRZY0D7DoGIzkNFaCc7VcZZosUnX9WFHSpv8xRBw2sut3pfLERS
cVu1aGB7DN0wvTLMLg+jqikXmSwVZt4y4nzX8WIaRTfw8m0I7JqYHhtyKMdVudVz
UkF8FhSg6oY/+7xIhVAO2Dhu5ngTxw4hn8VrK8ktxbqAhAMdLlA/Zu8vlqE+lM9m
C55TeACVk6+4GQA5VDT8wYY+TNz7gJcm2ws7v/ptbuAoTWnM0/u4SGXwnhlrBeep
OHsjtECxnqomP2ydqg0G
=ZSv7
-----END PGP SIGNATURE-----

--mFWIsQnH1d6uRhsN--
