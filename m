Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab3LKLO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:14:59 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36242 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3LKLO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:14:58 -0500
Date: Wed, 11 Dec 2013 11:14:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        andriy.shevchenko@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Message-ID: <20131211111451.GQ11468@sirena.org.uk>
References: <1385485462-30376-1-git-send-email-swarren@wwwdotorg.org>
 <20131210122159.GJ29580@intel.com>
 <52A750AE.6000903@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xYeFQzU4VZLrHqxU"
Content-Disposition: inline
In-Reply-To: <52A750AE.6000903@wwwdotorg.org>
X-Cookie: If your bread is stale, make toast.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V4] dma: add channel request API that supports deferred
 probe
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xYeFQzU4VZLrHqxU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 10, 2013 at 10:34:38AM -0700, Stephen Warren wrote:

> Could you also create a signed tag for Mark and myself to pull from? If
> we just pull in random commits from your tree, it's not obvious to
> anyone looking at the git history that we legitimately co-ordinated this.

> The same comment goes for the topic/of branch.

I pulled this one anyway but please do create signed tags, as well as
the bit about coordination one of the big goals with doing the tags is
to increase the trust that the code going into the kernel really is the
code we want to go into the kernel.

--xYeFQzU4VZLrHqxU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqEkoAAoJELSic+t+oim9oWoP/jD9ssJc2m+Ad3V5q6fRK0M/
nE5hyX825UTQWPuLN33O4AUBYYuvT56NnHPuOVz707cBaSjaBIRmXexWYWZAKBvT
Cfw2PzeKR3lmgN17eunIAlrn8m+SCxz3LlUrO6TDX4eyIdVhi9P1sUSQhUUhFijE
AwI+uIcHf2gLrwwXJzdyHpccnVCfvOIA8twlYqshEum30LaLWoIUCk4Id8P/OPmH
8fNAq5BngEWMhEfenqdUDbqhtiJ3EqGm3C4zVVBMa+srjzHz1w7b4amGeQbZeGSS
4RsrsG9Alg5vrcxi7orgDLgYKX/w/drKFco3KnPvRo1X8J2lMK7l6Z9rgAv3qyNS
DHk9yzr99TLDBqetY3B8iiZvI+CymgoUo1L4a6U54UgShSStNBSACNmhAXbGiDig
f+fmHKH2fXWyv0B/I6X9ih3MP/6yS0aPZzOXxEQPj8sk15yDPPpjkG7Pzr4YrR/w
RdpD3yBAXeFNjGe6nzIbhgKj3Fm0qqb9qD0TVeZ0kusTVo0GNBvUFtFaVlRU2kkQ
TNARLkUn46/+qEVE9muj364UsKBWTKB5k/2Xty1mOJ1ccGLe5f0rRc+OE2KCMUqJ
wWH/w2Ne9/9Y4IQY0zGTC+wNYElDdO5Kbkrm4+LhmIftQHlpohBQNBxZzzqxIC6m
fNWSF3zCFDmfQFxmtyO4
=F2d3
-----END PGP SIGNATURE-----

--xYeFQzU4VZLrHqxU--
