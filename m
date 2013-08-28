Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab3H1R1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:27:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37543 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab3H1R1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:27:09 -0400
Date: Wed, 28 Aug 2013 18:27:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Bard Liao <bardliao@realtek.com>, linux-kernel@vger.kernel.org
Message-ID: <20130828172703.GO10783@sirena.org.uk>
References: <1377705307-24187-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xFawzEZLoq+g1Byu"
Content-Disposition: inline
In-Reply-To: <1377705307-24187-1-git-send-email-lars@metafoo.de>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: debugfs: Fix continued read from registers file
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xFawzEZLoq+g1Byu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 28, 2013 at 05:55:07PM +0200, Lars-Peter Clausen wrote:
> The regmap_debugfs_get_dump_start() function maps from a file offset to the
> register that can be found at that position in the file. This is done using a
> look-up table. Commit d6814a7d ("regmap: debugfs: Suppress cache for partial
> register files") added a check to bypass the look-up table for partial register

Applied, thanks.

--xFawzEZLoq+g1Byu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSHjLkAAoJELSic+t+oim9pxEP/1i3o1zjQkb27tkqGyR26qCG
Kv5nPtEN1I/NVUHoHzBOxbm0RcOqThdpj71iAgyPVoxbu6FHD8TKQthlpG9DeFeh
2kNYPCFZT9enqFjIPjc6OqxFCDFRbgWoPYhfI3WoYfVo2tcLRDx0p0puCVHY4xhx
3zvLNz5dOEFNFkitwUnnH7cZR08I/25c6jbTrHaEh0KMd1n118t2zAg8PAGAYi8x
IibgbeThfKKSxW5koH4ZUGqvHdGEmZj4kQ95RBVYGSNsc0UyzgQpou+PTiH6MOSV
eb6ocCZAYfLsRI25hZfZb3DAqvgoyvhr+2cRvx7qFji3+ASvAbGnSLJzM+EhmjZb
qUM0G95wHE2wYGjQanik6xUc3Jcm9W1o9bVaIsMxJV0iaLoU5L/2PznODwdeUsmv
qoXYVRkdVQxf8K6+5OPecBeKFx5iy5CECKtIU9Ax6uZPxam0KRf9O35qvihz1EYw
yyqEaXmZ3G0FjqP0A70vZ/rV5Virk2sUsk2cnjJ2V5uHVntjOYn4Ex42RzVdbhHm
GE7H8HVDid6UdYAZ9YkdyP2OsassQ/NQVK0iMQ1tIV/EoyzH98RhdcY+5bM6uoNc
f15lUjVgDHek1q/i3bimpyAn2UukokyrsU9TPdew9LhUKN34Hyj18atXXgP/0iJf
NaPr0uOR/X813vWFzm9i
=LFa/
-----END PGP SIGNATURE-----

--xFawzEZLoq+g1Byu--
