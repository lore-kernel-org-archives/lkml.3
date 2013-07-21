Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab3GUXfG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 19:35:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52118 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab3GUXfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 19:35:03 -0400
Date: Mon, 22 Jul 2013 00:34:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130721233439.GY9858@sirena.org.uk>
References: <1372842992-18712-1-git-send-email-broonie@kernel.org>
 <CACRpkdY4MEJyY4w42yEStYUg+yMeP3uekVVi31nSd-90fOo1HA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7tPHY7RFL01rOa8z"
Content-Disposition: inline
In-Reply-To: <CACRpkdY4MEJyY4w42yEStYUg+yMeP3uekVVi31nSd-90fOo1HA@mail.gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: ab8500: Provide map_voltage() functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7tPHY7RFL01rOa8z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 21, 2013 at 04:45:23PM +0200, Linus Walleij wrote:

> Hm. Have you looked closer at this one voltage table in this driver:

> static const unsigned int ldo_vaux56_voltages[] = {
>     1800000,
>     1050000,

Meh, that's annoying - 8 looks too close to zero and it's the first time
I've ever seen non-ascending hardware :/

--7tPHY7RFL01rOa8z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7HAMAAoJELSic+t+oim9fPIP/3X2j8sHwLinGfWJVqu/Gv4B
f5M9pWysRnCFJ4tKIBP2kGQbj8CHHPdRJ0B5oJtZb80JCUA4ItpQUypTNTolAFTZ
s/G5iCBsbsyt6A0lL0c1WFhOuB1CtB5pJJbYmGPr3x2wjZzvSUQAOHgrwM4kYsUy
NCA7xZfc4M4cLSe6qWKI8avahL7cK8M/TWdN6WYaay+Gm2q6m6rZcLVP3DdbyG+7
b3YW1RQf5sKBhrclyvwDtr8vPJiB2lhS12stiAUzzGgP+qfBSVA6Y+2OW2BH2ukT
JIEQqPgkcuW/alSjoez3dU4wIAFdMTtYXpf8cisFv2Q5YoNrBVUOzl4rAPz458LK
g3UjO8gV0wCOFbF64yqLJk37m0QRbe1FcWDHiYDoXa6b4daTDG6KSg2xrxGIi1Kj
36GQfee2ZTyOb0yORy+tBIo1fr4IA/M3isXOT+axBg4u7q1ouP4vN+pEvl9s6tNg
H3Tmmov4FM22bCJ09zv2jM8mFPfxzIwPoma9QuDcCThQXDqv3E5NnFrHJeHxtiNm
IFdJVvru5RJokif9T5JpbV70ujAG03nZ+qYUnKEGzMQRf8ZrM0os6k3K2wpoqBVZ
rBC2hjHKxTrw7LCNRzTdcmGLz7FWx6NCil/jP2o7H6AHBLomOMvISbCLQF/UNlsL
P3p6ggwSweA/OBx6S49C
=OVj8
-----END PGP SIGNATURE-----

--7tPHY7RFL01rOa8z--
