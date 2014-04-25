Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaDYLPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:15:36 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44929 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaDYLPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:15:32 -0400
Date: Fri, 25 Apr 2014 12:15:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Message-ID: <20140425111515.GI12304@sirena.org.uk>
References: <cover.1398390579.git.joe@perches.com>
 <86cf3ef4915174777ea70f56c1c155f1e13fda0b.1398390579.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o6hfI2/SWjn0kRGC"
Content-Disposition: inline
In-Reply-To: <86cf3ef4915174777ea70f56c1c155f1e13fda0b.1398390579.git.joe@perches.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/5] sound: tlv320aic31xx: Convert /n to \n
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o6hfI2/SWjn0kRGC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 24, 2014 at 06:51:03PM -0700, Joe Perches wrote:
> Use a newline character appropriately.

Applied.  As ever please do try to use subject lines appropriate to the
subsystem.

--o6hfI2/SWjn0kRGC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTWkPAAAoJELSic+t+oim9zNEP/iTxFB4Mb0RuYnIjzFyPsPCm
blP8Tks8pYkjBHiuCDBUJnhUP2MU5bl+QIaDpEgNi+8SXuyHbqzRmCfuabhuM22g
TwcqF2PJH/0RKyYDN4hhQgzOKGWSsrJNF2P5Vw7QdzVV0wpm5pwnaMwe4rXaBnSS
tuP5urSn0BQHOl5bZrwVnbylVrUBPlgErFeKhFM/YVXE/eNVqV16Wa/joFmkpWBr
H70QeFe2rQSGwrtrRjSJb95niQUSaMcQNxkxb4rdQQe7s0ntUccCMtbFnA0/cV+C
SCDEcLq/A88GsYqDI2HN1E6608USV1yxxFob2FVUPd4HhpoBWUdMysN8lqzJR5dQ
L/0ZxyMJGwozG+x1pUDC7SMr+cZZRXC28Aw/JdvciF+ktrGiAFQDbMQv61GTUC0f
NC3CvbPP4Y/RVeTRDb8QO2rD0OUPArBdM0cN3+44GEGtgQdGZyd7KeaBxxqmXPNt
HJxYND6dxiIzjk9HgZMrw22rx2KH+jBvMxOLZHA65f6rfwpF6CP/iQQWCw0axirq
Q2KRLYzB+Q/zkXvBty96l+nuAlgBNhrb3XXaQP+AQ9b307QuJ2xADMzIxw3aJgLE
Yi7kHUL3EIcrVw1Np0uPzXZ+5Dx0KznH64OigQexlpe8F7vdHFqEWVpgggZqPXiU
DUyoXUwLVxP5pgfnM9+I
=Zb90
-----END PGP SIGNATURE-----

--o6hfI2/SWjn0kRGC--
