Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab3GHMKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 08:10:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34871 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab3GHMKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 08:10:30 -0400
Date: Mon, 8 Jul 2013 13:10:02 +0100
From: Mark Brown <broonie@kernel.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Ryan Mallon <rmallon@gmail.com>, mika.westerberg@iki.fi,
        grant.likely@linaro.org, hsweeten@visionengravers.com
Message-ID: <20130708121002.GZ27646@sirena.org.uk>
References: <201307021010.30326.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5OeNRVRLQ41UuqCe"
Content-Disposition: inline
In-Reply-To: <201307021010.30326.hartleys@visionengravers.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 09/11] spi: spi-ep93xx: move the clock divider calcs
 into ep93xx_spi_chip_setup()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5OeNRVRLQ41UuqCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 02, 2013 at 10:10:29AM -0700, H Hartley Sweeten wrote:
> The divider values stored in the per chip data are only used to set the
> registers in the hardware to generate the desired SPI clock. Since these
> are calculated per transfer based on the t->speed_hz there is no reason
> keep them in the per chip data.

Applied, thanks.  I don't seem to have been sent patch 10?

--5OeNRVRLQ41UuqCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR2qwXAAoJELSic+t+oim9G+oQAJwnzZqNrtgRtFfXtmnwWqjt
H2rBAKJqbIlfY/ekm+uTrv3qzvkQjbMD7zcLTi9j7JmyzegFbuH4Pe3VewvMaSDO
GU+JTYYxn1KVQFnhHRZdAgJJbZ+ObUsV5BQ4cOVUcMp+dJshaoAi3gsJQXmkEDan
8tqZoFOrk2WMJTTrHUMrSsBOEYKOq0isdCQEaEhiFezjmZ6dGv5VrzvwtmQ98ZeZ
9bOc69U2bC2a9ndmkQa3T+g85Tzc4dUNTZSlDp+oHJ0qqjXOMEKAyPR5Dn+93qdR
Np2FcR1rMIw+KN81BDaGA/Oecz+WzqcfiapiX2Gkf9kfb81yf60mC1be+2JlQLHi
PR1DA5F2TvEQhEJt7GSFPNKTpV26dhG6/YXnrK8zsmXWdrbqXqr8pwQO3FfCzZKZ
GrIWrevn4hMjq39UEfW4aErYHmuOnshc2fu4x6nTNOGuaKgTrosX6mtcwjR8kD67
bJIRXx2/by/eGkh8oayV7nWE0g9RX1XEpp8wTOfU9Wjtr8FptQxk3/zfNEhg8Bqv
GqARZstdZo1R3to3+Mgt/AqzFdWJwNoDMh7eNziSJFqURk6QUbtTsiBe3Ht2Dyzx
5ZAw7j2SBVwZgm71aPEQ/8eH1CjKqowKl0/4CPMzcsrvI/Jl+FubP34UX2ZHoFeo
rblQ/I11i4UPz8q3EQNl
=Px7C
-----END PGP SIGNATURE-----

--5OeNRVRLQ41UuqCe--
