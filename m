Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbaAWTtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:49:23 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58738 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaAWTtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:49:22 -0500
Date: Thu, 23 Jan 2014 19:48:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, shawn.guo@linaro.org,
        kuninori.morimoto.gx@renesas.com, moinejf@free.fr,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140123194850.GJ11727@sirena.org.uk>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
 <1390453370-29194-7-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NqSa+Xr3J/G6Hhls"
Content-Disposition: inline
In-Reply-To: <1390453370-29194-7-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 6/8] ASoC: simple-card: add tdm slot supports
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NqSa+Xr3J/G6Hhls
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 23, 2014 at 01:02:48PM +0800, Xiubo Li wrote:
> For some CPU/CODEC DAI devices the tdm slot maybe needed. This patch
> adds the tdm slot supporting for simple-card driver.

This needs binding documentation.

--NqSa+Xr3J/G6Hhls
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4XIfAAoJELSic+t+oim95cAQAJvhrpEkzgblNK+7xWFXFCXC
25yBW0vxiVlEOyZ7Gk8dxiFf9pdOlh53oz/iFO4vWsJ2SDhfR1morYeJT+qd0Gfy
TyaFJ2OyIOLnntGUxuYEjtjJ41nLyc0cJ1y8oJR1CE9qkshqck+YkcGTwYK0Xt2Y
ftAvpTXBMeOP5jb6i4Vvp24/mr0fMRubnLTgPYqSUjSqBtc4qnC91Y3GE8aV2FSw
uVuNnN3B9Jk4/wGlth2WD2KavuSeprQKYelTXZAXaGnclsOUBJBC+Tmwkc2JAmFM
ImU6dLxLwtONH7bOmC/SJYq8cSRzkp2nUSu3vIwn+DIMc4hoFRzJMzVhNYeIjA48
kL62V1Jxbe0mTzIvXd5Rc2Dq9aGcIkL/7IA7aAqRSEeTjIC9AjcQdxKNqSiRvhbU
zdtFkCyz2PbkHmKti3fkT2A1hoR5PuAJ0adlwux7VETudo+ioJwT+hZgpn8+LX+z
WsAfmXX20z83jxj10svHeN5dZGTH9PYNxFGTcgItd3yGpgmRos27YbhXAFXA9Zbz
ALRDXtF+txaWNJhFMncPKbuJNDSvBEa3bMi1LQxOo9SAch7eaydlyB3ynSrWfTD2
OsbGouRthL0vV+Brsdn+QNWdg6THZJc4AxXV5DIuMLYUWVYf6RiM8fwgJ6IfILuf
xoC95/hx5tlTSkKlLjLf
=w/Ed
-----END PGP SIGNATURE-----

--NqSa+Xr3J/G6Hhls--
