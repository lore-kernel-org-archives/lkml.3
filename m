Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbaBWHLr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 02:11:47 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49971 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaBWHLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 02:11:45 -0500
Date: Sun, 23 Feb 2014 14:34:59 +0900
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org
Message-ID: <20140223053459.GM25940@sirena.org.uk>
References: <1392914822-25825-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4tWrft2Hllg7Rgpy"
Content-Disposition: inline
In-Reply-To: <1392914822-25825-1-git-send-email-fabio.estevam@freescale.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.159.64
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] pfuze100-regulator: Return error on of_node_get() failure
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4tWrft2Hllg7Rgpy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 01:47:02PM -0300, Fabio Estevam wrote:
> If of_node_get() fails, we should return an error.

Applied, thanks.

--4tWrft2Hllg7Rgpy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCYh7AAoJELSic+t+oim9XQYQAIYVMZnXjVjZo0TDdBz9rEyp
65ZihkIRxoqmtfjzKkGLsobtFXCLExJaW6NB9eCW7xOV0+wOdAoB2H+bhCWmgSQS
LBoab8jSLuDtDOsmP7PeWM8/FYTZQ+ZJqXO5i++1UjEueLjDR3LFJLhmJgg7JP4h
bHPZG5I63wnelSAevjhVP8FTfOFH8qJzppM5PDC3p5udatEzqR+m/FLgjs1NQjpG
nWnvCrRIGg0/wH5KrLn6AfTU/Z4f2h1FISWPIkx8K/ahzyEr3R/xM25uOp75mdyb
OfzkkkHLrF72lJryIvppG3Xt5rL2ZunvEelga4oMDLTomZBYOuE9JdisKKG6Jx35
JCNDSvhxaX5PuC4IBNOQnrucOY96UmfPNdvhMYah0W/XLHw1wycoG7foKoMxMNGd
6ODDjpBB3DG4O53ttGXOCRaw/ybLWqbrg21FqSiN4ySSNjARaC1vioeMGjXAZbe0
xeMVprflDWN5q5aPKUIjMqXNyP5oaWM7KnSKktNLpj8+RJZRN7v4sHNAjM6ns1rm
z4zKT9dJf/RcEwqo9zRZsRQQR3VlM+Y6UJv4hpBcYub4Mdj/zb0LtfjbF13QN7xF
GNH1MDESD8vwjZTjdL7rXZAblN7V68fGY4cirJZEdCdM0ryy2HAXp/hZy+E6MToA
VYRIlDjKK7dW0Z3OQ/vA
=yv+r
-----END PGP SIGNATURE-----

--4tWrft2Hllg7Rgpy--
