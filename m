Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaBTLz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:55:58 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47303 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbaBTLzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:55:53 -0500
Date: Thu, 20 Feb 2014 20:55:39 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140220115539.GJ2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-16-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vVSe26ROzFt0lsLc"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-16-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 16/23] regulator: tps6524x: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vVSe26ROzFt0lsLc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:16PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--vVSe26ROzFt0lsLc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBe04AAoJELSic+t+oim938cP/jgOUxNoCDmLnMAWeENcvsBD
9ZoT0i9cCRvmXhFG6p+yClhwNF5w2pujKM9xB99x+bIU3XhLWrBzEW3zn1uptVSA
WkdJZndSbkj+kXsCktFfiXQgflpX21xTylAYId+6JRhfOTStsz6dTLL8LNy9NqKS
xjZN0EMk5H12J+qwcRMgknERNcFyiGXDZJtGJ+FredvEbMfXSQuEmk47BFffBMRv
v/JyHm4hLOJeVe3FVJPFmDAenneulbCZEQeXYKzS+BmyJOWTPD3u9gZ71BFbk563
iXeQMQNZPHbsJjo2PKxDK1k6xdE0pNRwzqlXZYQLPZJpzRwootn8GXbN2yoPb8Pz
6tExHrPvgMp5WU5nkCsn3SI+aAfE4nqK7TP55vcr/ULP9q9ZJ95ckKmWDD30Tj3R
05KcZzo0l6ORSHB23dArvIcW2unMGkFYbU26WXGLfNuVdRmEuh0taWH6dLf8usQq
ez37qYsE/0PzjLwnaDntAQrNPsZPllB2NPlU4TKO4BRgGncID3u32NR4gVK5ZBbE
0XaZ3rEIFPqSY8TMGJZvVFv1Cr+T1z6Ga/YzLApldAxYxIegFxYKBJZUa/Q9c2Lc
w5wtxT8zULnJraHsnovKxT5gAXRKgdL8LK8ByHaNl+bl3JdNKnvCYJLZjV8u+Nr5
Efzp5blaqv+Sp8ZLZ0Qh
=fZcB
-----END PGP SIGNATURE-----

--vVSe26ROzFt0lsLc--
