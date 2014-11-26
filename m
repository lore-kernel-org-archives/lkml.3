Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaKZTpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 14:45:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39758 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaKZTpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 14:45:43 -0500
Date: Wed, 26 Nov 2014 19:43:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141126194334.GW7712@sirena.org.uk>
References: <1415707485-28563-1-git-send-email-javier.martinez@collabora.co.uk>
 <1415707485-28563-3-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HvxUWqUQYk36AMou"
Content-Disposition: inline
In-Reply-To: <1415707485-28563-3-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regulator: max77802: Fill regulator modes
 translation callback
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HvxUWqUQYk36AMou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 11, 2014 at 01:04:44PM +0100, Javier Martinez Canillas wrote:
> The max77802 PMIC regulators output can be configured in one of two
> modes: Output ON (normal) and Output ON in Low Power Mode. Some of

Applied, thanks.

--HvxUWqUQYk36AMou
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdi1lAAoJECTWi3JdVIfQqO8H/ifaTgiQYAOHIoHtMRgpS2+w
VpmdaYOtReg2WDDJ6q7lIO8tGmFPRj6wtnbNT7gKKXPmy5VrjKKVxCgXLMtIWb+/
v5XfPmf+WXxtEPqUpxqnepBN0bgMdXOa7SMCnHgghrjwtuDHS5LI/HDiTfJMWmlN
dq59dvCkuojtGQY7WRn4tOVWqaKsC0zwBipghpUB+pXJnbIfJze7t5LDBwKaNXxR
8gmxQdNTq5PEfhui0ptsnoVoc7zP66Hwf70hNybxD09i/uarwO1GdpZnFl6C9oKR
5C4fwYe9x54KDqMSoJtpspyd/0c4IXdRWCNIDhoqBELl3J7hEIlebl7Dic3zN/I=
=aeW3
-----END PGP SIGNATURE-----

--HvxUWqUQYk36AMou--
