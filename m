Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaFIT7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:59:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34371 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaFIT7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:59:09 -0400
Date: Mon, 9 Jun 2014 20:58:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Message-ID: <20140609195853.GM5099@sirena.org.uk>
References: <20140609150951.GD9600@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iym2iLi12j4kk03o"
Content-Disposition: inline
In-Reply-To: <20140609150951.GD9600@mwanda>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [patch] regulator: 88pm800: remove duplicate PM800_BUCK3 define
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iym2iLi12j4kk03o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 09, 2014 at 06:09:52PM +0300, Dan Carpenter wrote:
> The PM800_BUCK3 define is cut and pasted twice so we can remove the
> second instance.

Applied, thanks.

--iym2iLi12j4kk03o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTlhH6AAoJELSic+t+oim9P1wP/3TKoOlZlE7tQnfX2R0j3XwS
gqkErSkQQAi7NpIfNG/IZa7BW+oi7a2o2kgQDDtKZh2KIKRKHlqTmyqvhc2wsStd
4w9c9otDj0t6y5g2BhNDHfaoIfqvvsz0IcAQXI4JvPgvzcBRt8Y6EgSfmRq+eIgm
50+6cE+hRTHCaQriKDI5AzuWKiZKtFyrIvRFHUXOT1Pu3I+ePyiLCRJNFn2hoEIR
8RY05gG0l+NWHEgVw4qrVhIJm/mYTJXRgSqfxk5yNizwf4sPP0sVFTn+bh/smGme
7wI/CAvHc1ELJnBZAGXJ/ons0qHLXsUN4PXKQ41xUoCRJBJamRW7HkxJ765/y2ia
mYQgV5KQWsTwinihAzx7RND3wW9IyaAAiDkM2Wcuy0rD0KCmq95wmuad79wnKPLm
m8vIEEWHZgd6VFpXmjg5luyu6dFwzrCPECqV7KyEq9ZeF+8K3YcXbBcR5pr0H+lP
EXgv1P0mbsAtfD6DmJb/7RANdWn5mjuMtEh5Rd0gQnBq3gXPO0UITJS513DckmU+
zITLigQQ7ywH5RkrXKIA0To79TCtag0tYHzk+kDuBPWIX99VVZBjSFXnATeqnbdG
3cAL9MclIevoGVk5ID7LDM2hmfif171NHWQs6dthm1S5kTqGDYdu/SRfRi7mtMrj
7qS8HRDWDbZJpDy3ntBY
=iZJI
-----END PGP SIGNATURE-----

--iym2iLi12j4kk03o--
