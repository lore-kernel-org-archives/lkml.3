Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab3FATKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 15:10:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36934 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab3FATK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 15:10:29 -0400
Date: Sat, 1 Jun 2013 20:10:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Maarten ter Huurne <maarten@treewalker.org>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org
Message-ID: <20130601191021.GO16790@sirena.org.uk>
References: <1370011513-10816-1-git-send-email-maarten@treewalker.org>
 <1370011513-10816-2-git-send-email-maarten@treewalker.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DITGHUV3p5DjDsXt"
Content-Disposition: inline
In-Reply-To: <1370011513-10816-2-git-send-email-maarten@treewalker.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: regcache-rbtree: Fixed node range check on sync
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DITGHUV3p5DjDsXt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 31, 2013 at 04:45:13PM +0200, Maarten ter Huurne wrote:
> A node starting before the minimum register is no reason to reject it,
> since its end could be in range. The check for the end already exists
> two lines lower, so we can just remove the incorrect check.

Applied, thanks.

--DITGHUV3p5DjDsXt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRqkcaAAoJELSic+t+oim9Lk0P/RAHtqTd6wckf1HFQM/llMvG
EpN9ig4/V7LJvvFdULnCo7wNKUJILNXE5Dv2xfQhUB797e9XlIFfAokP/q78z6PD
hVANBUCdk9wy9NpWGxnK1U5yyZEQombqVQKqgNJN1R4BwOi47h+EOvFD+polhRcE
3vWt4NYM9/a1dl4x/yPfzp2JXUPBirFl2MygyA9FhbMZnxqswtCU6bU6b5GTwRKf
ddJjQoElNNZoFZCnJbxdm+q1m6uDFBvFCtVO8a03LH/4Wr9oDVJzANhY0QkKQhrj
vdTEXfjf1wnSsOXZVolaWog6XbzPluF9nEbO0ZDfSPDYGB0VcnQBdOtUDiZJ+zf3
3dUPwJ0eGnfORdE2KJ8QXMMg6L31mPVv3rBHZNH/XOZBUxL9rT9s8A4E/95TgP0T
F9IZR63FCBoSjhXJpVqKnmCjv51LAWS7tqbXrLzEiwRwiru2d0J39daRpMpSTx/k
cosV+9ziKNvdk/LLATAyHWE7f/5Jc+ilQ+NdmLuaWwrVfoSJDOPLk5qAO0BFO66n
qlnerOQAlUYTC6HrFopRHlPrxdkdCuBRbF35kI7c1a/r4zphrrNiABEWxK6m7zm+
PQjlNb7aVvst/ftxMhQciyJQ3Be1or4CbVe+kpw/sdSrmK2kceSNDauMoyEJUsdu
wj74G3zIw7BISIpv1NAL
=3Dcj
-----END PGP SIGNATURE-----

--DITGHUV3p5DjDsXt--
