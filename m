Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaHROfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:35:08 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46838 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaHROfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:35:06 -0400
Date: Mon, 18 Aug 2014 09:10:51 -0500
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Guodong Xu <guodong.xu@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140818141051.GY14537@sirena.org.uk>
References: <1408329248.12083.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wwU9tsYnHnYeRAKj"
Content-Disposition: inline
In-Reply-To: <1408329248.12083.2.camel@phoenix>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 166.147.100.74
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Fix build error due to const qualifier
 for ops
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wwU9tsYnHnYeRAKj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 18, 2014 at 10:34:08AM +0800, Axel Lin wrote:
> Drop const qualifier for ops of struct regulator_desc.
> Allow regulator drivers to update ops before registering regulator.

Applied, thanks.

--wwU9tsYnHnYeRAKj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8gloAAoJELSic+t+oim9KhkP/jVIzJ9cIvieS54iz8NWQKsL
Hwg4HbY3X0x0BexWe+VCOCnB2LTE0ByzCRE6U6G99jeEzFb1ix+0msB7Y71kdM/d
c13DylCuwI6yr42Of6vRdDLsqCGF2Xa3Ni3sxYl38T7Ce8rrY+duEFtEi8+3ahoo
lIg9SPD8Bnbp1ikZ0xKxsRYF1vNY+LCorhx5G1DyIx5VktnQX738/ZsPXKogaOq/
PV1mUeJsXtJkEexVUDY4d93AQqQUtVZF91FcmolHx763yCjkMzsNamOWuS9gJky4
+8uzcsezc1Z7+vtrdTOk8VDqeqfYnzNT2o1QMHcq6mB7Wrkg54c90oW9JetAuCWz
Hx/Qgxmp7PbvIVG6ZEOwy8pjQWsaRPmW0KdQDVmdkv+XOzQYR1qmP5UVS36yMW3l
j0TaifZLf69AQN+fcnwXqpP8D5sz98EEOl+pOG3Jl1t2EsZvaW5ucfk3igUAz+/j
OZlwKTj5OcF5atGCa4iRyQ54uIJbItwqPymJGZQ9mghhOPvKvBo86hRmlkd3i64J
4SDeCybOS69uFVUXUgbcCm+sAK9Dxo4Q+X/5mnIeVbz+axDebyWQn4lJpoJsP0rE
E2JKAb/t1R069ACSxwRQaOMohuaNoOlmFfEYOhexmpVAhYGk8IbOnF/tHlVmyNit
jowXkqKt1/DG3z/8wSoR
=4v7g
-----END PGP SIGNATURE-----

--wwU9tsYnHnYeRAKj--
