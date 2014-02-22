Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaBVCoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 21:44:09 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48744 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbaBVCoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 21:44:07 -0500
Date: Sat, 22 Feb 2014 11:15:25 +0900
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Message-ID: <20140222021525.GJ25940@sirena.org.uk>
References: <1393011432-28909-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1ou9v+QBCNysIXaH"
Content-Disposition: inline
In-Reply-To: <1393011432-28909-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.103.222
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] regmap: Check stride of register patch as we
 register it
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1ou9v+QBCNysIXaH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 21, 2014 at 07:37:10PM +0000, Charles Keepax wrote:
> Currently, we check the registers in the patch are aligned to the
> register stride everytime we sync the cache and the first time the patch
> is written out is unchecked.

Applied, thanks.

--1ou9v+QBCNysIXaH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCAg6AAoJELSic+t+oim9Fa8P/2TXreuZSYF4ao/+shj/4Puk
+yxjthiS8aLI8ZyauYkNuGG39MDqAA0QBZn8OAt08m4NSeN6pDTK0ZZZQyR8bQCD
OqfvIv6CzpqXY72DnE8EPA8KjpqJZQHpilLf1hn3bNO4KIZ1hDsw2edOU+8yu9GL
nrm/epEkLg8zlfDHxUe2S9sRq3L4OPkGh/mnsNE3ujzytlaNLmgTio0+cFX+lMeQ
ckDLLI7KwVo9oliGd2mm+7BJucOVC1c+uZ6tMiWR4Q3/ujgrEP9lD1OqZDL/O645
Xx9hiSplc4xunZH6k7cgJIlUIWozR2oFr1x1otLpT7XMXTKJiU97Z/XMnEZnhyZU
KUY7L5SwumBORVlNf/Wqe3GfI7aUj9GX5XuyQ8pP2g6LEbn2AxqepWmHbu9F9Opb
BAQ4+buKqrn2Yd87kQJ+r6HdxEj+Zg876GR+hSPrzBqNaEi16SvuOY3P01B7S8Bx
XX9a+wu1N7zwypJKIrd7F8LQ4oW5tLpkKwL3Us+R6DhiuqDDKgRNHXfYXC0CUNxl
tFdYYV0GiByDQ2+DACG/YMv34i020BIgMPeAKuWzqGKQfhabfFo5WOzlNv0Ookvv
oaxztl1BTTKsvx2DVcsaXiDhLpzIdE8Y3ov18u/69t2hMclqStWVHTr92OL3kZm1
V/ulm8HDRyQhhfUShofG
=pNv/
-----END PGP SIGNATURE-----

--1ou9v+QBCNysIXaH--
