Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170AbaAUVnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:43:47 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57763 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154AbaAUVnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:43:42 -0500
Date: Tue, 21 Jan 2014 21:43:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-spi@vger.kernel.org
Message-ID: <20140121214338.GB17314@sirena.org.uk>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
 <1390339396-3479-45-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lmWPTIvm4M7zUP/T"
Content-Disposition: inline
In-Reply-To: <1390339396-3479-45-git-send-email-paul.gortmaker@windriver.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 44/73] spi: delete non-required instances of include
 <linux/init.h>
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lmWPTIvm4M7zUP/T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 21, 2014 at 04:22:47PM -0500, Paul Gortmaker wrote:

> None of these files are actually using any __init type directives
> and hence don't need to include <linux/init.h>.  Most are just a
> left over from __devinit and __cpuinit removal, or simply due to
> code getting copied from one driver to the next.

Applied, thanks.

--lmWPTIvm4M7zUP/T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS3uoHAAoJELSic+t+oim9KssP/0UjRPSQRdVnM59X2SWved2m
KVSMBXCt2ZiibCG+JETYR1VewYXmXO+SEWHzdA7YmgS4UDeljS4TQT/bwUZNRixF
fYk3p/x0UGhM5n8tTUYiGiVvhkyj0bORnjo6aOVrVT0CWdguCPt8nlw/x2K5mfUE
v/7E1RKcD2y6ZtnK6YS+K8I16u2CoQOoZHm9Nj74356uGRNClTygo2OokroGFaTi
Uwgxvr8JXnbEvDPZo7G21WV1croRXtROigW9zP+rexjUKGoK92unyZVjONEST24D
oK7MhtMccna0Kt2UGvaeaPpwvBNj+onKvRli+1cUq/bK+M/AqwEYobIn/u6hb2Qm
SEq1Y79uz33abR4gluj/H0PkbYGBmvUDE9bWRsPmEdvlLORCNVAu/D3dMJkElB8W
rOaPGzuX8ggohOhEc0GCh7kOBbiUH6YGKBWmzohHho0T2sEiZn23YVecqcyQHGzy
JobbrCK1mnnd1fUv246Bz/nygLQoNA0T8C7+3D07iv6NZ8sSSigmMlRsro7XjOjK
zIMyi3luO0KGRJFXremAqtzmp510UD3Fvk0YTGbGf7PvcsCkl1bdtErZtFrP2GvZ
I60JGIgx/eqjn2tIRLQbL3p1oRetHAQJ885jleFCzUl1yph3/eICda6sKPLgH0RV
fW3J+B6xCI9s1/3xEjZZ
=GUZl
-----END PGP SIGNATURE-----

--lmWPTIvm4M7zUP/T--
