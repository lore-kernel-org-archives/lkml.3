Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab3KUSgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 13:36:55 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39545 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3KUSgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 13:36:54 -0500
Date: Thu, 21 Nov 2013 18:36:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Felipe Balbi <balbi@ti.com>, ldewangan@nvidia.com, lgirdwood@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Message-ID: <20131121183632.GE8120@sirena.org.uk>
References: <20131120175814.GC27423@saruman.home>
 <20131120203400.GL2674@sirena.org.uk>
 <20131120205143.GA9182@saruman.home>
 <20131121024840.GA22970@saruman.home>
 <20131121104911.GM2674@sirena.org.uk>
 <528E3817.1010105@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gMR3gsNFwZpnI/Ts"
Content-Disposition: inline
In-Reply-To: <528E3817.1010105@wwwdotorg.org>
X-Cookie: I feel ... JUGULAR ...
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: commit c368e5fc2a190923b786f2de3e79430ea3566a25 regresses MMC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gMR3gsNFwZpnI/Ts
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 21, 2013 at 09:43:03AM -0700, Stephen Warren wrote:

> FYI, the way I deal with this is that my preferred email account
> subscribes to the mailing list, and I have a filter such that anything
> that's to/cc either *that* email address *or* any of my other email
> addresses gets handled the same, and dumped in my (list) inbox rather
> than in a mailing list folder.

I used to do that but I found it tended to create annoying duplicates
more often than it was helpful.  It's also a bit of an issue for me that
there are other people with the same name who work upstream so I do also
find people from time to time picking the wrong Mark Brown to e-mail.

--gMR3gsNFwZpnI/Ts
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSjlKtAAoJELSic+t+oim9gN4P/A+Z0Tw0RfwxEkZphiHUcVnS
O0+O9y1tND/R3CMB+MZHAAXELdpgWOif51K8eY6B/638oEWTngUbbajyEXvD2x1G
iWxMOc0mH50MYRGQsHADjGKrT5C5uwRKZi/Ll2uS7p2QPl0BQqXsTv0WAeLhcydV
8WkW5qigmx8h4FrOdgesMdLNwnMWW5W3LSEASBPP1Uq78iHaN8DqwYGMAc4D50vR
ID4x0L/6XCZn+EvDxWBzy4fHzWaEtPuZvjqwGydR/uc12X4B+6vLOjaoHHGmRoyC
DkVJ3Ufo7WaQKndpogEpHC5cIvyJE5LoQ5yvfgkmh3gtncSsvcy1VbdV7A0z68Pc
nGqLWM2PBBqzmwBDmBjIpWTIILgwT1EjCLBer1Hwg/9h932F3nVJ3m35Vbz+ZzWG
uu6NcUq+/D/YN3WnLF66ROhUK6OR2nWa1Av4Ztn6m2d1Dcc9Oi1CzDzWDe99JpUm
MqcXPbPd7KIFYGtHnUcCHgRUxBrCsiEDmNTeQmloQONIiC55EfimLYCbwFOtP/rU
7rYPsUCWfimFT/rckua+m5b8ImU/atbvwyagTM8IZsAbSRGlzz2OALYNlP1jk4af
UD8HxS8IzqMbqQfBo3LZhF9wGMaQC6du/pEirV+NUcJQMKbNYWwarD0QPd8zYhjX
uDcHfOAG84iPUTkRibwp
=kkGH
-----END PGP SIGNATURE-----

--gMR3gsNFwZpnI/Ts--
