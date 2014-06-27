Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaF0LzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:55:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:32893 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbaF0LzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:55:01 -0400
Date: Fri, 27 Jun 2014 12:54:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140627115446.GM23300@sirena.org.uk>
References: <20140527085755.4eab635574991c688f980685@skynet.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KHHg66sM3ACL179N"
Content-Disposition: inline
In-Reply-To: <20140527085755.4eab635574991c688f980685@skynet.be>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] sound/soc/codecs/wm0010.c: add static to local
 variable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KHHg66sM3ACL179N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 27, 2014 at 08:57:55AM +0200, Fabian Frederick wrote:
> Also add const to array

Applied, please submit patches following the process in
SubmittingPatches - CC the relevant maintainers and lists and use a
subject line in the normal format for the subsystem.

--KHHg66sM3ACL179N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrVuDAAoJELSic+t+oim9edsP/jJ5esR0FdZe7ndIa8KlPW3o
Imm5KiBXC8VnKAXf1TqLVv6uUkoeSVBYyIrt0a2D7QH0PoiZuT99o7dCVnfiPMq8
BSWlJns8ZFCv7w48lxs4l4WklVUr3AK2MPxZHLSEetNauroIgfpyD+oXY4ubn1zd
efrSKLG+YXu9XhFP64U1YO6q6brnnxN7+yYGDuwetqTApykAPC+vYyb2Qm9GUuCE
2bHzc1rKfsX9BLYP6fQRGG3CRting3bkSvzBHvkA97LvC6+LmOkrV8fN3qUS9WPq
itvZSnkK83lmxdNeUPGiGFT14V9bMAGQHXFAfU3rXJ9/MWuoSNqZWlRLis1Q7DEB
eorPKMHZp87qCI6LK4upA0Mc4n7k6eHB0eMS/GtFieted68K7dgCvkigpI5H8R0C
oGNyQLQBIphEzWXHThWynGf6jZlrkwnEye5i508RyqD751Eh2IwKHpXTal7lubw+
QnrKgYGGf5NdYe3bcjbBmjUaNt46RTtor5zSm259cXH9dDaWwLg3QXMaEaRpqmuW
s5ZlD8GylpZNEGQCMzyhgYrGTTuwihueBFfkyahy22HbmrYKbaJho8IKn1tea3iA
KZr2bISXyALwzMMMgEp0c+vMxHbHEJkhQlVW04TxW/aJjk04eRmARWvreovZn1B4
NK2AYUpK3L8CCN5jI1xS
=58y7
-----END PGP SIGNATURE-----

--KHHg66sM3ACL179N--
