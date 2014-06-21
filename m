Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934738AbaFUKSr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 06:18:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51764 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934617AbaFUKSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 06:18:44 -0400
Date: Sat, 21 Jun 2014 11:18:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140621101829.GJ5099@sirena.org.uk>
References: <1403259380-13634-1-git-send-email-geert+renesas@glider.be>
 <1403259380-13634-3-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A3zTz7JN1/RJCpqO"
Content-Disposition: inline
In-Reply-To: <1403259380-13634-3-git-send-email-geert+renesas@glider.be>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/5] spi: sh-msiof: Extract sh_msiof_spi_{start,stop}()
 helpers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A3zTz7JN1/RJCpqO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 20, 2014 at 12:16:17PM +0200, Geert Uytterhoeven wrote:
> Based on an old patch by Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Applied, thanks.

--A3zTz7JN1/RJCpqO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTpVvyAAoJELSic+t+oim9cnkP/RVgepV88BWoG+9TCoebGhFQ
XGtRgGuj81UrXL1Y7WIWdGYP68nA27J0OfIi4XnA7jIktLoaynj+a2OoP7vR/V5z
yAMdFsG0N6vqkBAYW/W67gMalsN+I4QZX1wyVXnqccCVYK5Ki45l1aLxzavwAiVn
i+Dalze6Hh8QWqmaAIi1UOUI/uYxn8oEF+ZN4cPBfBeAzdSatf4pnsG+vPra/NWG
2nznX7AVqsvhkbCpVJ46017+5Llo5uWPP0CyViGZT/pqq9cECw7xxw8pDe81/8zS
+xL/ap/ff1z6JkQnYEaR5vPthESXUgZnHsjar197TvYGOuQHpjipsxzkvu+S1b8c
rZfViDLL17ADzNqhGeQuaPXn1T9ggiZVGtxoauUxR2VD+QDqb3vc880CFw6oBbes
RF8cOdBbMtKvqWyFn4iyOurJDM/S0LmpaHeJ0wsi4wT7cilAt19H8pI9qcwa5opZ
zvxVZzcp0eWTM4F5bNN1CZAFMSFS4TtQWSt0EAonYg7iHpkk0AHvds79GoVRbmLL
H7JlnyA+lf83vKgOyD+9WlMcaAsr7P7j0u9dU9xFsiwT0t7CgQAXk4Lk6OqtJNtd
hMA/uvMtFUg8fNSAv/MREM+rfVWRuPNm8ihkWBgMCxsXhHQMBLV60oP9oCphefLs
2RLIx/WZumC2DcyTOQKJ
=RFlm
-----END PGP SIGNATURE-----

--A3zTz7JN1/RJCpqO--
