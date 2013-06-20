Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965408Ab3FTLU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:20:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55487 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964966Ab3FTLU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:20:58 -0400
Date: Thu, 20 Jun 2013 12:20:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: ldewangan@nvidia.com, grant.likely@linaro.org, rob.herring@calxeda.com,
        rob@landley.net, lgirdwood@gmail.com, swarren@nvidia.com,
        gg@slimlogic.co.uk, sameo@linux.intel.com, ian@slimlogic.co.uk,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130620112022.GC27646@sirena.org.uk>
References: <1371717458-10307-1-git-send-email-kishon@ti.com>
 <1371717458-10307-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IpbVkmxF4tDyP/Kb"
Content-Disposition: inline
In-Reply-To: <1371717458-10307-2-git-send-email-kishon@ti.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: of: Added a property to indicate bypass
 mode support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IpbVkmxF4tDyP/Kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 20, 2013 at 02:07:37PM +0530, Kishon Vijay Abraham I wrote:
> Added a property to indicate if the regulator supports bypass mode.
> Also modified of_get_regulation_constraints() to check for that
> property and set appropriate constraints.

Applied, thanks.

--IpbVkmxF4tDyP/Kb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwuVzAAoJELSic+t+oim93v8P/0BeY/xi7fRzCpxULHHkv580
uncSHR9Oo8CKeMBIdQVZJWtxF0h+RqdGhOs6i3V558FsC5qmrBduj6qK2lgl6LEt
r9t7KOFMxYCH/E8vDK7A0CeGFOp/YqSkr9d9iJRNbNH7nvO82fkIHSAoUYlpzGyS
bJHcahj3G086BOmxvwUj17YZCYLXQ2Padoem5htQo9V9KQLchbBhQEXXdu33s1gf
m8ChuigIM9L8w0WssNwsuHUf1J1dXgsRbDFPb5/AKU13O84oDCiBDYDNA2qVx6NZ
jNGKhnBA6DWP9By11zpC5CXkzumP4+OHi9qKurTnLPhfJGLD8azPRSqn6uuofd0p
cvuomUhdlWqRNPKwSim3A2gCNnJ5aA5QA3bSLBGE2IUANQJRXrB7xRfurlBarVcM
HGsJoTAkGRP4M+dDws/HazL4PGN+BGhLETL+IrKHwOtgD2vOoFaJJi7ZPCAwCqb1
eaIOWtucz3fvRVjZqE2aIADew6iT42wYelp/QxafjHaJADWPd0Wr+Ey95TrfljMK
nodCdS9dKDpyTSvmNcBjQIzHnAwXxiZpRQTRssH+v0mHUKi5w3HlypYbdJy2q6gI
YqXk0lEhNvv+mAMAHWw0hVkKycHLX0ofzLvo1IokJxWh0dpBvK1r+TiRY5UzHVKN
vSk7gNz9fWgSmkiEAyOd
=PgN1
-----END PGP SIGNATURE-----

--IpbVkmxF4tDyP/Kb--
