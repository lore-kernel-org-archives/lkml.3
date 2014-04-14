Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbaDNVHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:07:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33060 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaDNVHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:07:22 -0400
Date: Mon, 14 Apr 2014 22:07:13 +0100
From: Mark Brown <broonie@kernel.org>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140414210713.GA12304@sirena.org.uk>
References: <1396433349-31470-1-git-send-email-Li.Xiubo@freescale.com>
 <1396433349-31470-4-git-send-email-Li.Xiubo@freescale.com>
 <20140402195023.GL14763@sirena.org.uk>
 <aeccb18d5442446cac4030b86c3455c1@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <aeccb18d5442446cac4030b86c3455c1@BY2PR03MB505.namprd03.prod.outlook.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 3/3] regmap: add DT endianness binding support.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 03, 2014 at 05:26:57AM +0000, Li.Xiubo@freescale.com wrote:

> > Actually, if we're going to be doing this for all devices then we
> > probably need to namespace the properties too.  Not sure what to do for
> > a prefix though.  One for the DT folks.

> How about using one prefix string of each regmap bus?
> Such as:
> Prefix 'regmap-mmio' for regmap-mmio,
> Prefix 'regmap-i2c' for regmap-i2c,
> Precix 'regmap-spi' for regmap-spi
> ...

> Or just using the same prefix 'regmap' for all of them ?

I don't see any point in defining separate per bus properties so just
one prefix.

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTE39AAoJELSic+t+oim9hIMP/RMGXNwCBg2bCy/UdOYbeEm5
7VgkzJ1BNy34d38tvR0L/4T+u+XvY1kBqWvXkB2q8EovA5+UedeifcK+gZZcadnd
FtUmyrZhKnqtvur3qNqm0CdN12FPnl5hlEVF159rnBDh3XlYy3LeUD48w0o9JgEX
Z4hQueNXIKJAuZ2GEH0WY9/l3lGIkNo3ct5rG/7NGML66ucXvLMWuCLFg68Ffp9q
g5DQg/p07cQODC/P9gaf0dVgz0hVWLPwztXE1rn8KiCSn8477JuDYe74FsXF+L1H
WoEpnHZaEnS0B24F2gA4DFmU4UMXs/fJpP13/bWhdoWvebcyNFwU9gQhjlOXg8Uu
Q7/pYeP0MaCkgqZUF+0uqWkjeCkBsTzStK1KNnPL1TxDoCb6xJh5iFWt0sygsJV4
zNHa52aIDxiARhxjmN540CdRVOSJ12rUCEapHVVKtsb2jdvTaKTUujRmaiLNkhhz
sr1gRJkLJ4E62U2ci/yvnpE7N12T+sHcusahQ3s9BPbdbSfvKrG1oU9yRP6jmjnI
mnY/JbB0GkwCAF/qB/JftLnRPVWelgAjZd0lKaSGBWT9cSN24v7INL8l2Ub1LEO6
OkCuTy1D73Jr4zL+5xPhlWrRd6Auft0ZAn62pIe2NRsGt+h1sKYH2J6zxqnzXvsT
qTMo4dK/HMbapi8bDSOr
=0Oog
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
