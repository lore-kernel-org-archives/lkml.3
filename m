Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaE0L02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:26:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44148 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaE0L01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:26:27 -0400
Date: Tue, 27 May 2014 12:26:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Robin Gong <b38343@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140527112608.GU12304@sirena.org.uk>
References: <1401098173.12646.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3bPWu5NYmHG+H1wP"
Content-Disposition: inline
In-Reply-To: <1401098173.12646.1.camel@phoenix>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFT][PATCH] regulator: pfuze100: Support enable/disable for
 fixed regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3bPWu5NYmHG+H1wP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 26, 2014 at 05:56:13PM +0800, Axel Lin wrote:
> Current code has .enable_reg and .enable_mask settings, but the implementation
> for corresponding callbacks are missing. Fix it.

Applied, thanks.

--3bPWu5NYmHG+H1wP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJThHZNAAoJELSic+t+oim9ogIP/Ro6D605SV2rP1MFyP14sfx7
Gu8mBfl4KL7MF4gOBMNjtrZ54uN8jd4LNGbo9Ls2LVPP03JtZV+Wtt0g+1IOxCz7
vnorUENs9tCVmPpccsbbx/pG5T16RrpV/9i2lolTVp1DQbKooCP0Ark5ORepqrBv
KfqjBDOCCVnEw8Sgcli7DodDAN4WRx/yTfGpiuCbFNvG/SWcNvO2k3/0MKTTVdbE
cUdPO/DaW0mxzqtPKaatF1vm7DNM1UjNTa/fveAnGwpvB+G4d6bAUoZmTpF5MeFo
xbRY/29CdKcQ2bD/OAYJZxPmTTnNiDUfw1kNN0z94TkzcZNPMu15Gk3cr8F9f1hN
apH8YvojBF+HucQ9r2xRdZ9iRtJjbMDUVRY9rrRV9G5wb7URO5xs8/RWtzBLq/oi
Bre7ZkbAAE1WNss/kQkQx9lnELdRPtMglM/WNoeNqwTaK5/1sElJD72CXpZevFmh
CB6sMPRjsOaEElb2sDoH3pWBIUAuSjwEas8EjKbscE9JCNk09iD4MkVb8oRZo6K3
7ZQ6eHmUMxVxrzAIiB8A2bWwgUVTfHwU6pNfQsayYtQMDMR4DVMzZoWL6McZcEo9
EmN7LkVoq7sQO+GlnivGszJH6NrB/mls1p6OnLDsm4lsAd37SKa0PRrO9euz+ZfU
2e6HavxV5yPCWrVd+WTZ
=SKek
-----END PGP SIGNATURE-----

--3bPWu5NYmHG+H1wP--
