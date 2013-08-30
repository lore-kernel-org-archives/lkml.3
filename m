Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab3H3Pml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:42:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46391 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458Ab3H3Pmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:42:40 -0400
Date: Fri, 30 Aug 2013 16:42:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Bard Liao <bardliao@realtek.com>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20130830154213.GB12809@sirena.org.uk>
References: <1377877173-16987-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mojUlQ0s9EVzWg2t"
Content-Disposition: inline
In-Reply-To: <1377877173-16987-1-git-send-email-lars@metafoo.de>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: dapm: Fix auto-disable for inverted controls
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mojUlQ0s9EVzWg2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 30, 2013 at 05:39:33PM +0200, Lars-Peter Clausen wrote:
> We need to make sure that the control's cached value is initialized to the same
> value as the control's widget->on_val. Otherwise updates might be lost.

Applied, thanks.

--mojUlQ0s9EVzWg2t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSIL1SAAoJELSic+t+oim9r5oP/0xdg8ZjcL0lVCOebQ82prR3
lO6ic371hujm2XVeuFDwKVYtP4Ig82yhvnbVIjgC+KIAGHPCKOf+c7aSjZrAgFZv
rnySujqLwYLuM+Jcjz13LL4bvju81ckapv1EBeLzEvE+n+BTARzg03BF/GT2eLzL
eOwqG2Z6NLG3nkcIs9yj9AImpVuUQxl+XVLABrFlwOkYyDZQAnxtrFk1MU7s4mMo
qc48kNMCnUdfcbNDots5qwpTlLg8xdtNFxn9a0F037DG/lUuf6/ia2D6qR6gMSVP
piwG/ApQc0yM1jUTLUWRwZHhxWhl9MvhMVibd9T3HcGiDhKskAX4GQUDPHDJiypt
1yOMYGXMvc5+MV3eX40lPIPEQzvNssLWFr9UgxhcAxpoeVPtyFej5+f9Qlb78/zJ
yAnjj1GrTEcmZ7F2HQA2HXPX3oLMIfTDPvAAFI8+Nlx7Xv3jA9JzsPcZoN7KAJBT
7d3FVqsnPb9uTgDQJr1kI6Zlf2xSRTfLd4eLcaR+Bo/fgaj4od1xmbq8QRAWKxFK
jmbcvL0GFJj+stjGBHNAU/Z7qgDjYR9MhahoBtqKMRSkbIA2TBZGgsUj/64Q7BU6
1fdg1FfFzlyaCZ2Mv6IzPiFW7OXufOnVuTow7OCaZ9ji202MJnyN8en12va1PIv2
75zatRfg5k4sdVFZUccR
=uCNw
-----END PGP SIGNATURE-----

--mojUlQ0s9EVzWg2t--
