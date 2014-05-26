Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaEZNbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:31:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43098 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaEZNbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:31:14 -0400
Date: Mon, 26 May 2014 14:30:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Simon Horman <horms@verge.net.au>, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140526133049.GZ22111@sirena.org.uk>
References: <1400782055-19609-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y+bLae2mFylWGq1m"
Content-Disposition: inline
In-Reply-To: <1400782055-19609-1-git-send-email-geert+renesas@glider.be>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.165.144
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: rspi: Round up division to avoid slave overclocking
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y+bLae2mFylWGq1m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 22, 2014 at 08:07:35PM +0200, Geert Uytterhoeven wrote:
> The calculation of the bit rate divider used a standard C division, which
> rounds down the quotient. This may lead to a higher bitrate than requested.
> Round up to avoid this.

Applied, thanks.

--y+bLae2mFylWGq1m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTg0IGAAoJELSic+t+oim9GiIP/RKxYEXXCk49kjMxe+WDHZ9i
TXHPCkwdfPJJUWkcXNxlOt/+HTYLUfG/DjVCGSfzarZV3FXVvlsHAzBtpkEwsg8T
dgcI1Z9FOY0N19+iHSwrgMBqzdSxKan3AfadEDKmIXDmlwvZaa6hmnyheYAvRkmn
EEl7XoqmKoC+xq6gw+3H4TFYZcBN/eWoAfZg55k/yy8jKeSQZDARuTeOBTJAMZ7t
euOioG3NKjDBBVAyUOqxnycBe2hhILfYW8llaPoRBHX33XEs+FbUW4GhI6/8X7kC
lSgCVq75PW7xRO40epkUyLK65BUNFgpVVksfI7NSzfjtQpmMJD9SR70YuKjCkz73
30wHJv1hhcu/D6j5m94kp+cuwt3fVRvSh+aHmbyiRn2AKXMcoOkoah0nDA2IC0GL
YonJiO5Rgbo0a94+7ikTTAFdVwr8iWDkPkXXUYJz5k/QHAWpf+08Lj3hmIe3nyRL
n8CBK54VNeTrUe90dWdYDcX8w1lcUuEOD9BQgaoHXpH46PeImLBtaxqBydANHavT
2GJ7tFLwyA/k1c/fcOUhzrpFJXrMNcI66me51GDe7xHjv9ewuBJu18fkcwrqlgoq
N264IFfYhPyGHUfCmDdYQ1WJkTdT1GH8yMrpqGNYniUoBL66r1HoJeZvhf7zm50Z
sfJRVAo29AovaqrTIS0t
=iysl
-----END PGP SIGNATURE-----

--y+bLae2mFylWGq1m--
