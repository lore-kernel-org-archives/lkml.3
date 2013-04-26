Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab3DZPbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:31:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36174 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755329Ab3DZPbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:31:50 -0400
Date: Fri, 26 Apr 2013 16:31:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Cyril Chemparathy <cyril@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6524x: Use regulator_map_voltage_ascend
Message-ID: <20130426153144.GY5019@opensource.wolfsonmicro.com>
References: <1366957552.22992.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R9qb+eAX/AZDW6n0"
Content-Disposition: inline
In-Reply-To: <1366957552.22992.1.camel@phoenix>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R9qb+eAX/AZDW6n0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 26, 2013 at 02:25:52PM +0800, Axel Lin wrote:
> All regulators have ascendant voltage list in this driver.
> Use regulator_map_voltage_ascend for them.

Applied, thanks.

--R9qb+eAX/AZDW6n0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRep3WAAoJELSic+t+oim9aXoP/iplNLrdwDcK15Odga+zrVIH
jTn86tKltJIJQ5aJuf0gGPbly/zjYnUJgbymQp4idbK/IMe/XjfI7/YRb22YFHZZ
sdbpWqEuE0lRlO3nUjRnv7MElslIAFdv5H/X++pIxiH8hhsJLbrChdhmeFgSyR+E
qj5WJ4aN0TjwtWYaBBPMaxFqSjOoOU8x9r8dmO8l5+sgpP2HJOTmqep+wn/m0Byo
YVWR+ZMDuZ7iaLjbsEUFCk1whlo5qXNIpS7R2lATFcnfkfD1XeP/5lN5p1lucP6+
JymrqDlISHU0QeAFvz0ZW3FKooytCHqhlZYQnGhu9OnM89RJ/7ZGMKDlM3FSvfji
bQlkOSCxfa3qpJ0a2Nk0JONA1AotLwgg0ISnIJnXk7mm9lyyKJ7beY+DOClSk3G8
/yhNqlJc9IyyUNXzw74AhSjIOBFKdpiTeZUUR3UksVvVlwDx7MH8vUwhh/5sugma
mp+CzeVAoPfT6ikON6rvsFufT+gHxpFAgIsO8p4p7v7yu/DFQ2g2ULCoHGZn6O8m
vtbFexgeXy0s50hRqPcB2j2hxaKOZ9zRAWwEncnLaIqswzFiXdjOJClLQKVxOX4r
FLSNLxa/CpPu28IVUUoQs3I+I30bS2P5mLXpcSyoV6he1Spi7wUcY4NTCC3G0g4B
TxevW3hCTz7olLhb3ha0
=K8YB
-----END PGP SIGNATURE-----

--R9qb+eAX/AZDW6n0--
