Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaBOKN7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:13:59 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35660 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaBOKHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:07:46 -0500
Date: Fri, 14 Feb 2014 21:08:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140214210803.GY4451@sirena.org.uk>
References: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LGr9gtkSK9ARF7Ax"
Content-Disposition: inline
In-Reply-To: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/16] regulator: max77686: Use of_get_child_by_name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LGr9gtkSK9ARF7Ax
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 05:19:47PM +0530, Sachin Kamat wrote:
> of_find_node_by_name walks the allnodes list, and can thus walk
> outside of the parent node. Use of_get_child_by_name instead.

Applied, thanks - and thanks for doing this cleanup series.

--LGr9gtkSK9ARF7Ax
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/oWwAAoJELSic+t+oim9YKsP/R8skaGikJL3rylgV+m771x1
NoFAfG0tuBxnqEK1jXNBinJ6m7Fnbbe8QSQpDlj19bGKQpDh3coFlYKAqpPTcG62
IEksH9JLKpBYyNgxD9BpLiev2Ni75sHfOzGSlcneU9jy0BDZWFIxZmjwlifXZdlm
GbEW1EpqsQOz4RHUbLWOZIZo80L76sxe7eTizv9sDxHT7GuFepjkAtj8MUjhfTQc
I2uy8TdlIiBbyPun3y2oLdHlu7ZvdtmdVhm+bFOPz8FKyV4zT1CX0IUxrKDcETkr
7hOF/yFdd6tob1EFkGFk9XKRyBDo2jp/4vuxXVmP4F1MbhsAS4HM6i+dG0BwSsO6
9iPnHAZD6pVmP+rOlrJKS0UQ3v5H+MfZ2smz6FQ1QjcAXsAl5BqHfNUE6SrF2lb+
E+yNZHAPiNtHEMu2RcTZzztKLuMGp7oNQb0uXjOFpGS9kvZyodiaRDro0ppHVGd9
4Wh+dFwqvgYZlv2OSWqjDL+oas6p1BYhIR5j5iUZFDxtWtH0IgOqKDtQNm0/0wOz
jZySpCVkkhQtxcuXLRTvwB+uqD0fTUkwEYxgcJ77X4cJ0Q3sV9vmkwJsa8Ay1FW6
8ghqLH+nQ74XEpvnyUA82RTsBgKfck4kck8bgCUc9W0/+iYJ/EdF1+wklFCW/P0V
tpULcD1jMVY+XLWvQdIV
=4J9T
-----END PGP SIGNATURE-----

--LGr9gtkSK9ARF7Ax--
