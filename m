Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaEZP4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:56:37 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43400 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbaEZP4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:56:36 -0400
Date: Mon, 26 May 2014 16:56:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Message-ID: <20140526155616.GD22111@sirena.org.uk>
References: <1400250334-9397-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ET6UV2goafmXLl1s"
Content-Disposition: inline
In-Reply-To: <1400250334-9397-1-git-send-email-p.zabel@pengutronix.de>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.185
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regmap: mmio: Fix regmap_mmio_write for uneven counts
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ET6UV2goafmXLl1s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 16, 2014 at 04:25:34PM +0200, Philipp Zabel wrote:
> Commit 932580409a9dacbf42215fa737bf06ae2c0aa624
> "regmap: mmio: Add support for 1/2/8 bytes wide register address."
> broke regmap_mmio_write for uneven counts, for example 32-bit register
> addresses with no padding and 8-byte values (count = 5).
> Fix this by allowing all counts large enough to include some value.
> This check was BUG_ON(count < 4) before the last change.

Applied, thanks.

--ET6UV2goafmXLl1s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTg2QdAAoJELSic+t+oim9g2AP/RbUrelpYuxYKZufz9ZXoFOW
j/ShFSomakvHVHKdHsPof7ZQIiMH6uMhgpth6v5ysx5TEMt1GkqSEcdl/PwEwQU1
eq0fI8d1cymWEeSzAAMwUjr2NcehUyxJWV7sPpFNovJTwad44OUa/KEx7LU9157a
GhasKzaoATwvzMjd8Y5mW7SgcPCe44G1U/w3XXF5gMJmYDeyRuaozKcI4Dbl2q+o
50dT+iCEn+/sgvwfaa7EkGoOLBQEM7c2V5Oh/N5rbnOmA38rA2A3IUbiAcw821uH
9OB87fIpf6YOeM7h3nS1zNXQnlwaAjNOsVOFNIBXfxqvsXYKs85C0j+rZ6HLePtV
I4Or6yaxg+8bWsC7r1GfU+KZPZ7IJg4AR76BCpoozPeCEWD3MjHGAy8guSpSCqiO
3o84L6bkKNkRQp7ENkMo5bqcZrvVOgxh43h/FzifIwx74k/zwknlE4dJ1Fm+gXFi
d8mZMSZbcIS53OBylaIvtXVSxfCKWiEzayjURKn2azqd8uWEe5GQjDeI4Dhf8H32
0e5NJjAsdP4LYOPpdQ+NnVRGQgbjh/ywT0wgh5EwXciRUbXIYy/hiJ2Qu7bTpqdL
/RAt9U31EXTeVAyFMAD/7/CZ6TS7TVFTBK86oXDp8pGH2LnvMq2y2WXqRprIH/pe
q5/Y/B72BANid8ihOD4z
=SYY0
-----END PGP SIGNATURE-----

--ET6UV2goafmXLl1s--
