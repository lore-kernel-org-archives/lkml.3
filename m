Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaBOKHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:07:39 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35626 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaBOKHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:07:35 -0500
Date: Fri, 14 Feb 2014 21:18:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140214211851.GJ4451@sirena.org.uk>
References: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
 <1392378602-32302-12-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/IVwS0tI/jLhqtjh"
Content-Disposition: inline
In-Reply-To: <1392378602-32302-12-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 12/16] regulator: da9063: Use of_get_child_by_name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/IVwS0tI/jLhqtjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 05:19:58PM +0530, Sachin Kamat wrote:
> of_find_node_by_name walks the allnodes list, and can thus walk
> outside of the parent node. Use of_get_child_by_name instead.

Applied, thanks.

--/IVwS0tI/jLhqtjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/og3AAoJELSic+t+oim9ZS0P/3ouE0pJ1LbLjyjyyAbkxFo3
o10QG4GLod6ssMJnMDtxcU+eq9jRtWgFmjgQnhfPOODRo8R//GessBK9kl+fSWIH
B2xnaxLJL3NDGaetLvKYIhHLgB9X+u1MDzn9BSI+9zA8Nu9g0H+1HCWu7D9x3Pgh
iZTRLDBAiUvDaUqEYWgo1PSeCG75dADbbBHlOgMtHxQe/vFpWbs/o6LO8jr2fDnd
YPL4A4CRRczZU2a/0E3IOQo/HBUoGl1kyc9oX7uRl44dJRTmZBx8zyEDhIZxVjcS
I++Cb0nnTf1QAFnwGgRRz5qXJpy1ZZwhdpkIsAkDE+CnZPyYY+oSEa4c0big1gOD
5S0SjjzpQZ/GvhgR62wd14IC1X+ZxkDELh8cJAVOIngIMIzlnnhMDUDRxKUR0ZXU
In95kev7jCWx+VqJwFq92tEmb+2gXVq1xyUhyVdWorUx81bO/7y4UkWBsKDwNg9u
2WtLmMUkXb1rQ0j1s4r6aae+QCPExwij7sSWKkJVz/4uBuG/l4vthDvRpx+8aJPW
38RipUDT7sRgaDn1JIWiaeBapaxYmu05LQIwrrfmjcv2CczNMO3jrWExnR8QPthh
SFpY2w0+ReAKCK6ALB5Iy/Z6okHvtpbjC5DuIkrbgU8vUZMURqUQ2fq1DsCzD1Q+
+9ApWYlQ/ngz54VDc+BN
=5IdK
-----END PGP SIGNATURE-----

--/IVwS0tI/jLhqtjh--
