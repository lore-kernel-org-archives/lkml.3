Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaKUSPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:15:12 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33986 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaKUSPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:15:07 -0500
Date: Fri, 21 Nov 2014 18:13:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20141121181332.GY3815@sirena.org.uk>
References: <1416512485-7292-1-git-send-email-joshc@codeaurora.org>
 <1416512485-7292-4-git-send-email-joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nLgjwVFNYHlBQjnm"
Content-Disposition: inline
In-Reply-To: <1416512485-7292-4-git-send-email-joshc@codeaurora.org>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] regulator: rpm: add support for RPM-controller SMB208
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nLgjwVFNYHlBQjnm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 20, 2014 at 01:41:25PM -0600, Josh Cartwright wrote:
> The IPQ8064 reference boards make use of SMB208 regulators which are
> controlled by RPM.  Implement support for these regulators in the RPM
> regulator driver.

I'm missing both patches 1-3 and the cover letter, what's the story
with the series - are there interdependencies?

--nLgjwVFNYHlBQjnm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUb4DMAAoJECTWi3JdVIfQgyoH/RStcwZ3J9SvKpPCuVv9SnUB
5F93+DF7enTylUhndqiqXUR/j3al87zeyVOx9iQnhGRzqGkHM4ZMmE3JSwTLxa6P
2bWOFWyeyFa0km9xCmIfSgtIGTpJJpH7TyNW3uM/jVo1gQgOafPPmspzFWLIjWce
bhgQYypO0+lcXvm80oSyeS14Vn/8xJMwmkoeoqQATHR39OP9BHk189gFWSXXu/Jj
1LTunuRAxOSfWJCM6rOKvlpt9x9mBsc0cDhmowgfZSWkbIqNhdFHNvd21v5PwmwY
h/qUOCH6WuTSAc5J1VFtZ6caeV1XjtIGu81ZrFJze/ET4ZJ2mKfWTWtJ7yD7k8c=
=PJyn
-----END PGP SIGNATURE-----

--nLgjwVFNYHlBQjnm--
