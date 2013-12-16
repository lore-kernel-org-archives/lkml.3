Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab3LPLpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:45:39 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40602 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab3LPLpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:45:38 -0500
Date: Mon, 16 Dec 2013 11:45:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Message-ID: <20131216114510.GE3185@sirena.org.uk>
References: <20131216164721.79bfe996919a8ec3576867c7@canb.auug.org.au>
 <1387177714.4280.2.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6e7ZaeXHKrTJCxdu"
Content-Disposition: inline
In-Reply-To: <1387177714.4280.2.camel@AMDC1943>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the final tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6e7ZaeXHKrTJCxdu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 16, 2013 at 08:08:34AM +0100, Krzysztof Kozlowski wrote:

> I sent a fix for this already on last Wednesday but I forgot to put you
> on as recipient.
> http://thread.gmane.org/gmane.linux.kernel/1612360
> Fix is needed also for clock driver and on Saturday Rashika Kheria
> posted similar patch.

I've now applied your patch (which fixes both regulator and clocks, the
separate patch isn't needed).  The big question I have is how this
managed to get into Linus' tree - why didn't this show up in -next?

--6e7ZaeXHKrTJCxdu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSrufDAAoJELSic+t+oim9ZEAQAJxzwRYLo4YhdZjREALG4Oge
r5tbqYYe5LrRjwShdYnJYs8BrQ8Utp9bU5mBy0lC6qJgqQVPojb/kPzeLHFcXdFs
YyqKFOEgF163/fgFxrEG4gmbmOD+2wKLtbPQ+I8mUVwGsGSFb5vK8lSjVsJciKco
yAKzqYziUH8mq2i7fG1Wpe/hFHj1VK1JYqHRBLf7oLc2y1n1EpwMjrLvgQ8IeLIq
pp9yxWDxLTDC4/wiC5fB3GttoVVWSTFwopN7gDu3dgtyzBXNYUnM4tPdjeons4pb
D+TgJ2JfnJC45xaQzjRGm4JjRrwNZ3qe6X5S0yK/lL3p3FVGQvhs6Lm/UQxpqjxB
lKB9OMYePLCWGzHySAKJBPPzqYpmsjBa67wb3ZCycegmVCujwwtiJGcQ9xUp+kCw
kIFbWu+sk8n1Tl91ZnC4WNr2gtgI7mvacjGVbphp7E47U2DKkTzhywzoaqEhbQQf
npssHYBUZrD5b0JdhnqeBYOqUWivQnvN27Fe06Zh74+KrlgIVoQLYZhweI46jMr1
Y/+jEhq13zfsn/hOoIn7Yzok1aiYL4ASUhwl9Ph6XWHIYn24j7dPNLHnSlRu1WR8
ASpQtovdeFalDSz3fHS076SjxUvClKaFbrvh+KZqSbNWMUC1w9nK/ulxxsHpnly7
JMGRgxr9uD0/GapzSaMM
=dlSS
-----END PGP SIGNATURE-----

--6e7ZaeXHKrTJCxdu--
