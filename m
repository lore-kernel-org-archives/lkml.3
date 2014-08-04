Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbaHDOu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:50:29 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45916 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaHDOu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:50:28 -0400
Date: Mon, 4 Aug 2014 15:48:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, timur@tabi.org
Message-ID: <20140804144857.GS30458@sirena.org.uk>
References: <cover.1407125653.git.nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cLlE6j+44ygFdGhU"
Content-Disposition: inline
In-Reply-To: <cover.1407125653.git.nicoleotsuka@gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.223
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 0/2] ASoC: fsl_asrc: Fix two dereferenced variable before
 check
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cLlE6j+44ygFdGhU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 04, 2014 at 12:19:47PM +0800, Nicolin Chen wrote:
> These two patches fixes two warning of dereferenced variable reported by
> Dan Carpenter <dan.carpenter@oracle.com>

Applied both, thanks.

--cLlE6j+44ygFdGhU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT351WAAoJELSic+t+oim9NToQAJUF1XjbsAlLJBtudz22BZB4
pT0zwdKzezTIWkiCRqJA6WLcI2uotofSUEOyj+Oyp1/DfcS1/1GPPGKRV5g/sZn8
lKJAQhD7K+dJXqVgYcjz42DhTGZq55Drva9T+tA6aP4745GYsYqOWnTDZONNBB3d
rbIPUgXCiL47Kwnn/dHSQLsFEzwUdiQc2cOBzBlykim5k1eQWefhZp8Kw85wN+ea
cNg3T8eWNP/FFbVxF7l/des/7KY6y3QAm5wRNFPDSOOhcoN87OhYmmeZpoDl7WqO
Kc1pxGjKY8EOMd6nZSC3uID5vqQwuBRHWU42I0VAHO7/HLAJSGPYIzOBTsYDUNnB
vD0z0HnWa7kWnuqVi7pAc0y9v37Am/xSZn8L3L9Fga3SQxPvxMtxDxZNP2uqJFEY
9pqLigIw/aXSFm6fjVK98ZJgbMNU8+sFjhtKfjdU5UXZQ8cNaHT9GlJwlrroXmPF
ruyI0WDklicdatlInhbs3WjyiHCWX+Awr0ZDmeRVd9cEzhY22SEDIqd0HZK/gu6+
g1th0bZrPjSMb7Eofdl4gOoeyEhv3HQH9Dtwd6VxnySaTj4YzFYldtHELiyNQFpH
PIwcAp2eyOAdVWTARiH6jUXO5M9sLuo12YmMenuByvq7QrbRyEzgvSpkjULI/X1H
p5iIxT6ioswgvNtQnXuM
=22xm
-----END PGP SIGNATURE-----

--cLlE6j+44ygFdGhU--
