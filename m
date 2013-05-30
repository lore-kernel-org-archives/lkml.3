Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030543Ab3E3KuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:50:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35527 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030465Ab3E3KuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:50:10 -0400
Date: Thu, 30 May 2013 11:49:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20130530104934.GH5180@sirena.org.uk>
References: <1369899460.23034.31.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDnEQgWzhgf+8aPe"
Content-Disposition: inline
In-Reply-To: <1369899460.23034.31.camel@x61.thuisdomein>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.128.224
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: OMAP: Remove obsolete Makefile line
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDnEQgWzhgf+8aPe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 30, 2013 at 09:37:40AM +0200, Paul Bolle wrote:
> Support for omap2evm was removed in v3.0. But only one of its two
> lines in this Makefile was removed. Remove the second line too.

Applied, thanks.

--dDnEQgWzhgf+8aPe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRpy67AAoJELSic+t+oim9Y4EP/iUtZB4Sk6RTcCOGkreB2nd5
o8v0/IGoMCk/75BD0UTB/AenW6Wus4/INm1hsUPHoW1uGxI69Y63ZHqkiOMAwwQu
c2YdLqvRoPsjBFMGewAhVl9LS9ASMXR32FLJFUux4JB22vouNTzzX1Gc6w8lmNrx
tvpqVtt7ks3tyQ15N9wxkwVodcd2ectpkp6XS8ohmHy7Ueyz+csjrQCthsiD15Db
6SwyN2b8i07vPDNKTvYab4RCgewIWwZVtwocvgHPj8tOsvZ8Yx9tjTD6+QmKt9Ur
llAlmKwlx4EJBTZV4gcC9arfhd8JDq93Q6Cc3JZDFgspqcFtFhSSDg/WImyOjaA6
0Uyhqa8ln7o32y5sgY+K+w8cuwt2n5BRkJAI9UrggqXIn4ovbVNkiehGCJtxh/u6
+GNKkw+EbAD1s+oUQgMvSUGsgHNMBg1LZ1Al9AAY2xqbxjGFFjSnb4BiVyE4+5X2
iGS0QrVzTthD66CQFI2fQx85fmgKd90fncB6hEx+LzvWqC/qKX/46y0OfbB+4EFA
2D6p72sVG9a/DXq/yH2I7N/yR4D2e6f/a9+cTrN/iYZkNvB4Wx6qrkc911mI0x7V
MJiWa/oTLojzZ3nnvV1YDVQZpuYAMpI1VCP8+1jUFfuCb0tZWe3hhGuq1Z/ct1Gp
VlOkJRCx2+6xNbkDLlEJ
=L6CF
-----END PGP SIGNATURE-----

--dDnEQgWzhgf+8aPe--
