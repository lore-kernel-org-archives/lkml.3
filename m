Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaJGMBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:01:21 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38473 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaJGMBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:01:20 -0400
Date: Tue, 7 Oct 2014 13:01:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Message-ID: <20141007120106.GY4609@sirena.org.uk>
References: <1412626635-7404-1-git-send-email-mpa@pengutronix.de>
 <1412626635-7404-5-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sT0SRK93LqpGW452"
Content-Disposition: inline
In-Reply-To: <1412626635-7404-5-git-send-email-mpa@pengutronix.de>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/5] regulator: Use gpio_is_valid
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sT0SRK93LqpGW452
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 06, 2014 at 10:17:14PM +0200, Markus Pargmann wrote:
> Use gpio_is_valid instead of custom check.

Patches per driver please, this isn't just a mechanical transformation.

--sT0SRK93LqpGW452
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUM9YBAAoJECTWi3JdVIfQ04oH/RG9T4+eZfaJXafaD4SXABO/
pgJ6dFdAYzmb0033dk9DMlE3SvYjE84vIgt4s3XAPSQv3hK13xg3caedefux82ve
Gh1R/mqjQbrP/HDIQv88yb9V0ibPIT8pNbb2dZxAI82xxrEOg8KcAgAJUjodWbLU
RPecg/QyurW07H5ZfoTS14pzzXldtiQzd0iLS3UfSDYCi7OO0hTjiy2z5za5ZDki
RJ7nn+wS6+ufJS85uTcWGlUyyEqqqpRgq9V14wbcwHikGD6bruSi4zDl2qhlhI7k
JxF4uIo1u2+7oMpjwUFXDJ1TaCIDxlfLqROXkknDeXCrf5Ypq/lxuZMS1IeTg9U=
=70NP
-----END PGP SIGNATURE-----

--sT0SRK93LqpGW452--
