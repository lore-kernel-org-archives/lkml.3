Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735AbaESQ4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:56:10 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33387 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbaESQ4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:56:07 -0400
Date: Mon, 19 May 2014 17:55:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140519165551.GH12304@sirena.org.uk>
References: <1400497954-1012-1-git-send-email-alban.bedel@avionic-design.de>
 <20140519143949.GW12304@sirena.org.uk>
 <20140519172556.17c49589@avionic-0020>
 <20140519161838.GB12304@sirena.org.uk>
 <20140519183749.170aada2@avionic-0020>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q/XUzdLT4QcFxo5o"
Content-Disposition: inline
In-Reply-To: <20140519183749.170aada2@avionic-0020>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Fix the init of DT defined fixed
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q/XUzdLT4QcFxo5o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 19, 2014 at 06:37:49PM +0200, Alban Bedel wrote:

> Unless there is some better proposal, or objections, I'll submit a new
> patch tomorrow to call _regulator_do_set_voltage() only if the current
> voltage isn't correct.

Right, that's the best solution.

--Q/XUzdLT4QcFxo5o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTejeUAAoJELSic+t+oim9zi0P+gKHUYl21LgwtxBGZPaocI7P
vdiImNJmNEBGb/BqlhKjgXUldNsNzbqqoWoLlc5/S/Nx+hfMQn2R+DvXtjpaNOOF
pBzPQbjRVI27K22pCjUnB1t/CiwAr8kpw45l7gftKsQGYUdgt9uB7GstKWly6xi+
GHwCUcJrSK63Dz/KxB19KBqUJTYv+CIcSEabIYAk9Ah3WuN1qH2CEEzUyYvfd3Dj
UkPZqmhm3hxYfBZ7J1Gkrhii6Y7TZBjt50HylDr4GN3njQ5MKdjz8Px+AUoSwXXI
1yWACk/WlQOgTOWG4U9E4ZDvtbG4/yezabfVteerZVLXjTbxT/vI7pdKbgUvVKzk
5yi6t5BcxSpTrkSLNCHTdC5yaQYt6GzkebWSKTepH/lrAHhcHxoO2ZXFBWOC+THt
g2Fu15or0jm0yVnsHUWx7lafdgEiDgI+JKs3ZzUOFifwXWoxe+QSIJTPXaR2ssvL
58u4ftd6FaQrtNAI9uwDNN7Q3dhnsqxcXOhTYMAlQKGBZ2/mDmVyC3RZKg9QNEqn
2doWLJdh+vZoKNyDa/5GFoTmsz201lX8sErClF2MojI86K9lxJVMEH2U+9lSwUN1
qr/ZzZk1R+OAf4bv/J1JnZq2wZPy0w09w0ebWANNn+nqZHfviHcTMJ5PtyS2EV9c
W/cetN4qmPQMQVK4TR2j
=iD7Z
-----END PGP SIGNATURE-----

--Q/XUzdLT4QcFxo5o--
