Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab3L3MCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 07:02:20 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51297 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab3L3MCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 07:02:19 -0500
Date: Mon, 30 Dec 2013 12:01:55 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20131230120155.GM31886@sirena.org.uk>
References: <1387946278.6422.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nc/lueCMLdgjBWoP"
Content-Disposition: inline
In-Reply-To: <1387946278.6422.2.camel@phoenix>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFT] regulator: act8865: Remove set_suspend_[en|dis]able
 implementation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nc/lueCMLdgjBWoP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 25, 2013 at 12:37:58PM +0800, Axel Lin wrote:
> There is no suspend enable/disable settings mentioned in datasheet,
> so just don't implement .set_suspend_[en|dis]able callbacks.

Applied, thanks.

--nc/lueCMLdgjBWoP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwWCwAAoJELSic+t+oim9OzAP/1EGWlXaqQHECT7Dt4qk7FIu
MJbgbpvdJIraIvRUku6eF3Qf3z9idZY717hTEZUjKURV6yIJsHSqKrN6Gal9sobN
10fNTbHLUO8W27taCAnooVxUIZeVPHiN3JH2/2PY4KsF454InqZojfQBnjNj1Jga
F5aeCYXUD4gizlpS2tOf2OhsCmv0mv21YLh/iob0KJ/2RzXFhjWA5p57gpkMNbo3
AxUnKvcBZzcmINGuAwbyfq1LYeymJLIxrVsU0kf5wN6gFNCvsyjCk6ivZ2wB1ole
KOpI6XXHgha7XnbCtEEDJBlu2D+TKUutdKQoFbs/XwIO5cxW+rVmBwJGLuCnwgYF
k6nvwAYNHpwFAKzkVn40tTF9nMnYmcoyI4CpTBb2i28R3YOFojMFdWuvF58O8+Rj
eAHDf7i405uitVZw9ux0BsBHODSy4IwZVxOsXmIFMt2WSKhvmABk0eJs/t2rQy4D
Xqh5va5wEEowcGzTbtLLrfQIi4UvliBazS3Vpcq91pxcffjOPa360WPtP3/oHaiR
86tCD03ZkxcGtQg3GWE+P5chnzHjPYY+gh67BddRLstz37HVZ/Pj03Fl7Bpn/tWT
JTcvgK9Rn/lrzL//2AWjcCnDefOZa5xyqOHK84fM0WvJclAfFaSeOsu4PZSy7CPg
LuZTH/8aTfVQ0KqsGLZp
=ufds
-----END PGP SIGNATURE-----

--nc/lueCMLdgjBWoP--
