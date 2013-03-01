Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab3CAHiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 02:38:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60369 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832Ab3CAHiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 02:38:05 -0500
Date: Fri, 1 Mar 2013 15:37:36 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mike Rapoport <mike@compulab.co.il>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: Use dev_err rather than dev_warn
 for error message
Message-ID: <20130301073731.GI25302@opensource.wolfsonmicro.com>
References: <1361327026.9733.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BghK6+krpKHjj+jk"
Content-Disposition: inline
In-Reply-To: <1361327026.9733.1.camel@phoenix>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BghK6+krpKHjj+jk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 20, 2013 at 10:23:46AM +0800, Axel Lin wrote:
> tps6586x_regulator_set_slew_rate() returns -EINVAL when having slew rate
> settings for other than SM0/1, thus use dev_err rather than dev_warn.

Applied, thanks.

--BghK6+krpKHjj+jk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMFq0AAoJELSic+t+oim9VNMQAIxoWNEpsOBkFK731piYUeeL
09u+zSgPFIXKwwpEaq1E9wtSydYJUxFxEM9W6ca6IP4ClGHjdtnSaHjaWvyYPS0t
alfAHBuc0zVpiPuLsf99pu1urMTvt7WO3q0R5AxYgmTx3iy2iS68pJ44d9GFNdKP
tRCntRMHxBcZzDW5g+SU0bTR3bDE9XxeYEgJ9UXq+ulHLA/MkmX1UthJ2dSkwuHP
yZXNltfkvwdFqFLbDLppgK7N7WWJCXLE+ApaJ2UOlRaHFdaML8fQdshK9Vd1I0u/
fY+fwcH8nKO0M9dH2qwbgIpmVaNFGOsGvyxfL8qcy6Cp8TDaPRtdqL4R1jZuwafX
jOdsFD13Jf3ZIh67RNtCDWtHvCaBgd0cQddIedcd4wgJKEiGVZ2+Io11hUhDBPvX
NlFw7kkgEV/IAhy05XZ99aL3PafWkLKM3MuPEUI6Zf/nQu5/i9YaPK+w4AQm8dql
//HzaxZ5RV7fwxyoLku2bSnM6T84kjupwunkj/Ru7bxH99cYxU2yvywk47QbZELw
T2f8FSyPsNZPu9rRXaKqLuJMubAOzHCuAMgFo/IznetAZphInfcNySVzWBXpXnf3
Lsr03p5n51YeHOCAzYD+uVWmhLjHip4Bf3UXYTlTYZm4XMuz5/S2FhE8Ti3JIE0O
/GT6EJ8rRjLygBKkiT0g
=D1Vg
-----END PGP SIGNATURE-----

--BghK6+krpKHjj+jk--
