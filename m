Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab3HUP23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:28:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59308 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab3HUP22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:28:28 -0400
Date: Wed, 21 Aug 2013 16:28:23 +0100
From: Mark Brown <broonie@kernel.org>
To: David Jander <david.jander@protonic.nl>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130821152823.GE26118@sirena.org.uk>
References: <1377090155-3443-1-git-send-email-david@protonic.nl>
 <20130821133200.GB26118@sirena.org.uk>
 <20130821162143.42ca91de@archvile>
 <20130821144442.GD26118@sirena.org.uk>
 <20130821170846.66b5b1d5@archvile>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y2zxS2PfCDLh6JVG"
Content-Disposition: inline
In-Reply-To: <20130821170846.66b5b1d5@archvile>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] drivers: regmap: bugfix in regcache-rbtree.c
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y2zxS2PfCDLh6JVG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 21, 2013 at 05:08:46PM +0200, David Jander wrote:

> This looks better. Not ideal still, but at least the codec works!

> Should I re-send a patch with this fix?

Yes, it's not the fix we actually want (we want to be merging blocks)
isn't going to be suitable for a bug fix - ideally I'll get this to
Linus for v3.11.

--y2zxS2PfCDLh6JVG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSFNyUAAoJELSic+t+oim9E20P/RVuJ2oQk8mwEv29z8Yfmrbv
T62/AkXFJSpchC//A7Vfaw3jVnLHbcnTOzTI1GaOsy4959tD7PM22VDbt/zB51as
IaxllvZCJ6s+jr9Tsg3A+GALgLAno8AJz4ygGCb+lWuLrkNdGry9tm2CD+xWgBbC
YsOtdgbYQsrvrOFvH/yfQV5SafjBVWgOU+Hph8qwS9FUvDrxKVeO5S9ZyqHX5r3l
b3Bo8MRIGlUivqU1a9GFXtGUrTZkGl2VPhIxFo11vRCkIbXO85UXQGWK1UtxWaYo
dbvGPwLUS4C8ssKmPyu3vXGbKVqlBGPUCK9usCQSF/dtb/LS6oIsWDN9XD9D3lbq
yGxs+YwsxAAJRUIR7OZb1hmr8Cl/UloleGjpU/G6dml8p/Bt0ijgJNswrPsC8nqG
i2Hvf6hUiVPWIFMFwmrDMWMPVTxWjKQnlH2S6ZiD8PoDfCeBBDM3LLWnqljCVpVL
3PIVQXJ0ZqOywutujVFoPBVB51fOizkYIf1wNIyl9OrXBCnBuweQdIxqW4QzXFLs
SjwH/6XLi3ld1Lmv5zK0TYL7OfwObolEojkkmcqutKkUSm+vGFmLM2dLqWQuK2ex
WtjoWtn5X7BBDi5YwyPNjDPC4YJXjVpVEc32bG1ym9ZuXK+p4p4abiGSMsWYbiyt
LrTS107NAs7Bn5l+H1AA
=hc2j
-----END PGP SIGNATURE-----

--y2zxS2PfCDLh6JVG--
