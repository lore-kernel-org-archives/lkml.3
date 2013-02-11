Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab3BKL0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:26:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36599 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755577Ab3BKLZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:25:58 -0500
Date: Mon, 11 Feb 2013 11:25:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2 v2] regmap: debugfs: Add a `max_reg' member in struct
 regmap_debugfs_off_cache
Message-ID: <20130211112555.GC4607@opensource.wolfsonmicro.com>
References: <1360327634-16669-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Uq4LBwYP4y1W6pO"
Content-Disposition: inline
In-Reply-To: <1360327634-16669-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 08, 2013 at 12:47:14PM +0000, Dimitris Papastamos wrote:
> We are keeping track of the maximum register as well, this will make
> things easier for us in sharing this code with the code implementing
> the register ranges functionality.  It also simplifies a bit the
> calculations when looking for the relevant block:offset from within
> the cache.

Applied, thanks.

--/Uq4LBwYP4y1W6pO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRGNU6AAoJELSic+t+oim947EQAIBFHdXHh1u7N5+/3RN+JbeU
9d5+jnEqqBPneSAsoPAryTQ66IZj2AWBKEqnMh69z4xpm7CbO+3+mi/Eie2GoKPO
fHXEoerG9SOfGpI3OWQkRHM1KLdD36L8ZHQcZklo0zspBdejtWhwoowN1nCo+7zE
nwsxAnx5WzD6uP7hIlTDYAkc2Z/rW+VAf6rEf9WUHXz3zsq31jrsDmFvYs0WX2c3
2Tx8gC7d4APKL2fqqaYgEBNa0wCgCk10VxIWdToX7jjhwSqk5pADwEb30ZnXJ+Q3
N7wo4CbD24Ctg/XcVbiEgK7YqMW/hhc1guUSR/h/UOO/WZxzWc7JVSmlXNbGMG+W
0EmTMIairEdQGJ+oArBZJrKHj1FwywKfYo/PpVX4zP8F+CHCBBEoSmVRpONl0LBe
xIYc+ULG//U17W/pCGdn3pv8xvMOXVf+g86IXXF378fffiIJ58r5bH9EesEQ0d1T
z6sN9YDc2xZXTpwAxeeRg7I5oX0b2P15KrjMf7yVl77wMCYBzlG7GaxT7obHgZeP
T7Z2TKgjIx3ti0YSLBwtFS4gmyH1aGXIybYFPilPZlPdkdIXKN5BGHkLD+gLwcu0
MXN2N6sFi+GSZs7ag7NS6UPmPugoOYKbMd6xOkzhLCp5UKEJX635YkqXB//iuJo/
yco6rNs8gZAXPil/MFRX
=VL3U
-----END PGP SIGNATURE-----

--/Uq4LBwYP4y1W6pO--
