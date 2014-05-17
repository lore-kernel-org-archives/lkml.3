Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbaEQN1O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 09:27:14 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59901 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaEQN1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 09:27:13 -0400
Date: Sat, 17 May 2014 14:26:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Sachin Kamat <sachin.kamat@linaro.org>,
        Axel Lin <axel.lin@ingics.com>
Message-ID: <20140517132655.GY22111@sirena.org.uk>
References: <1399302603-1427-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4YpuVpvaG742Nl2X"
Content-Disposition: inline
In-Reply-To: <1399302603-1427-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 217.44.186.29
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: s2mps11: Fix accidental enable of buck6
 ramp delay
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4YpuVpvaG742Nl2X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 05, 2014 at 05:10:02PM +0200, Krzysztof Kozlowski wrote:
> S2MPS11 supports enabling/disabling ramp delay only for buck[2346].
> Other bucks have ramp delay enabled always.

Applied, thanks.

--4YpuVpvaG742Nl2X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTd2OcAAoJELSic+t+oim9e4wP+wdbJv1uKoDyTg2rXBFleieH
5KzhPyrvBHgzvVWcKTyovBH1S6rT0CRtAH153foCrm5FDuofinusNralfwoTe1es
CgirhyIeLR4FZLGphoH9D9cu+yAD1BluRdZzWcMeDwmTYc6Ry4mcVjX0ABmMdtmD
XHgZ3NobetaaPzii+SSoSyEo0hzzgeAB4JK23s+7sHqD1AZ6E7Ee8CCwYjd/i7E4
At/38jqYXWSpAINqGUDN7z/90utB4MbJsSDI69lKFa8H8kiDjVjzMdcEJSJ/drim
UlAzmWH9CXp7alVYBGi9OxhUz/i9relYkNdBn3bRcYE5qhJTWnaDW6mJbhhK/Pu4
FhUwT3O86jmpkNFgWJmYFrKIZcDQ4pN5lFPn7l2eg44Z+xpxhp3Oo4PDO3TwiVg8
jH7ZqyvqYUf5nVQRNpLkC3AAHzwzhfHb5m5uTOOp1gYIRKmQvcArWhBaooN/GT8V
YUcfRQ/ta9WVVsdhS5WxEBv7YTZh/nHYIUMBHwNcCh2CU7+jIlJK7nCIJGjoQglY
NtwY2P61/0xJ1OK+0rdrFT+3pQVoJ4TttrABRNDLxwZVN/bpSf7k6A9SJs+mefxl
Wh/4QwLSXp4lyvjAqQXnQJBljGusrzHyWHQe8NdHmWyZFuS0YZOVewcKckwu6JBQ
RAVZ2vqrWbi2Q7qhCnS+
=sy5k
-----END PGP SIGNATURE-----

--4YpuVpvaG742Nl2X--
