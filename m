Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaCJJgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:36:00 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50034 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaCJJf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:35:58 -0400
Date: Mon, 10 Mar 2014 09:35:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140310093552.GJ28112@sirena.org.uk>
References: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
 <1394440371-29588-6-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZJM0Iyk369AH1/Ez"
Content-Disposition: inline
In-Reply-To: <1394440371-29588-6-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 6/8] regulator: max8925: Remove unused state container
 fields
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZJM0Iyk369AH1/Ez
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 10, 2014 at 09:32:49AM +0100, Krzysztof Kozlowski wrote:
> Remove fields from 'struct max8907_regulator' which are not used
> anywhere in the driver.

Applied with a fixed commit message.

--ZJM0Iyk369AH1/Ez
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHYd1AAoJELSic+t+oim9IhcQAJwZ59zCaSanKi0PC3SgmSir
nNbpCdwZ3aIIiL2VOb/OnnugSBwhQb5uDqmrZOUUlbA0Rr4nRRZ3Tbj6JuydGqRH
pIab4ceMpNKemR++KXEf/L7LvcjoLsc50Ule5iOtkYsLJKis+zjR6INkSqMWVZQL
7l+y7TAA4DKC+hbM1RhhTZ4VqI4caldC9bYLYxOK7OPof+19uATwGuml4bCTygOK
ifAPewcMrJA5X/4mvT9rRX1Gvf5xxThZ6t9gmotAt5msE2Ij0grs4v0zTyeiO/NA
qOk4LPqhM8RzOJhzA6aN6DeX25+b9lezgGPci6joRG0XEbItlEdAkHbBH09cqjNS
s/DM5vYXswom4OPCn8GKuOqbUOQhTzL/d8aBggS5hfJCHHheaGKYz2+mGEDuKq7e
0lXge1DfzqJZrkb9zrJjfOWvyrce+1r6wmd3WremY6La68GZ15+QIZoShZYbuwBB
5Ivp0KYQkT7abo0K5tZcDg3XYyJJIW/DZM1VtA6SM/b7x7CpiPxFSK38N0xTnR55
jecNbRgfZAq2WmbRZU9a5hrm7h1H1T0Sq9u5Quzl/VeVzvUEEeaO3hsaPMYe1s6U
b5UM1yu5mdYB6dR615JruwFVRjS9+h5RkfzyH/zNyC7p+FR2qUMn5tMHAeqBB1sM
XfFT2hDF/JpcVUwVOV//
=HzLQ
-----END PGP SIGNATURE-----

--ZJM0Iyk369AH1/Ez--
