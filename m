Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbaBTLtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:49:33 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47276 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaBTLtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:49:32 -0500
Date: Thu, 20 Feb 2014 20:49:24 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        Sangbeom Kim <sbkim73@samsung.com>
Message-ID: <20140220114924.GE2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-11-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0Oofp5lML3vIYK3D"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-11-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 11/23] regulator: s5m8767: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0Oofp5lML3vIYK3D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:11PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--0Oofp5lML3vIYK3D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBevBAAoJELSic+t+oim9IpwQAJE67qa9CiWYlq7RGmmZzhxN
QRNMk1wlUU+xIVHd+MjXzn6h+cCLf6j1Rb3utHugmakTL8Tr9XCIZKzVRb6aCMVd
imBaSHheexkuw9cI5yT5MXgfT3WYq+6FxnU7BfUTMOprSJgnO5KVd2tEYBUWNe72
Y4+KVp0GDWjaj7mP9uVva03UlkvAoS4HkWF1rlYNHj013u7OiJQiaZeEkf0avco/
1c5KWEflDLHopR6kwNIRX6OzDraEzdHsi8jWnmUaEC4lyjv5BrUycfRl7FCTatcG
xqriWWIIPwmXWwozwyYWs/IfzJtsePQBRQTyo93Z5MhXpHECCG8BpclnEnFi2WkK
ki/Wop9VM5PqphfwwllZYU4/1un+Wix2MAfyZo0PYVQDw7v1WPLu/R1m9PdRpEt9
D9llbJrvJfYRduYqsHzvXCHrMx7wbUOJXIt50EPJ7/7/txaMOAeaAQARhQHFlAWz
s9eXgMHUctv/fX2QJSi6btPsG+3MPeIbvrSgMaR6+CWX9VphQNH4n4jQkic2kyJ3
VXmO+RYHWKRmyiyY9ooxeACCo5EZYbTSNvipR80HeFp8GOpCD5zUSuyc5s6SD1kR
lmjTKcLZzDu3+n7cRVraWPubP9G5n1GRZ39TswDOKCCkDPBoM0cD7/IlCCoiYMqU
/tWBn3V6TAFSsPKoQiTv
=D+Dr
-----END PGP SIGNATURE-----

--0Oofp5lML3vIYK3D--
