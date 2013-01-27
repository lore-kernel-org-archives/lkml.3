Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab3A0DWC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 22:22:02 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45512 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755508Ab3A0DWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 22:22:00 -0500
Date: Sun, 27 Jan 2013 11:21:49 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matt Sealey <matt@genesi-usa.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] mc13892-regulator: correct/refine handling of the SWxHI
 bit
Message-ID: <20130127032146.GF4650@opensource.wolfsonmicro.com>
References: <1358789920-1341-1-git-send-email-matt@genesi-usa.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nYySOmuH/HDX6pKp"
Content-Disposition: inline
In-Reply-To: <1358789920-1341-1-git-send-email-matt@genesi-usa.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nYySOmuH/HDX6pKp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 21, 2013 at 11:38:40AM -0600, Matt Sealey wrote:
> MC13892 PMIC supports a "HI" bit for 3 of it's 4 buck switcher outputs,
> which enables a higher set of voltage ranges.

Applied, thanks.

--nYySOmuH/HDX6pKp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBJ0+AAoJELSic+t+oim9orwP/2V197wBrmMwbfoX7dfXEH8T
dn5dh638hknJuy73ncku60I+Y+Zv/1idTupjfWHUxdx15+hxh3sZ5Szj1NBwxnJH
3bT7Sz87xaCfFp9fkOyv9Cw/CVesITAnZzYkwvmfbkUGfcBctL73GfKAR2k7Pwwn
z8RsY/fIybU1ejXQgDJZMpIgEA77IOBf3yMOTPSM/SsGnDr5eeYWITo2EVmIfz7U
zyjU6mfQonIQbgaUh1bzNN72yJavGt/KHbeBkqOS/q4f1u589c4s/g9WGNsxl7VC
bJ9Z9RUH6Zvo8gYeLu7CMlZSyFmS5awwKCgjlJ+ztaxIl0ysV7OpBTEDJETYYSFd
qkPF4+teNTLuYFqSYiSfU0rhnECLIFETYhv86Lg2/OsUV7kOtzTAeZNDTUXcJGsJ
4EeLLWperaV3T9tR11Rh6KZ7lu/C57cgbvQkMAZ2Hndpm88FGvWAa9J46j4bo/gg
a4eaVnrMpkz39t0aGuWPHw8fcoR9Bi6qgF/xJymnT3yxEdaWSEVfjHj3z/YcWieB
ky/3WESpB9FHxSkACXQnVGgmu1uDAPgJ397cC1v8OKlsXXg0/aHSHZS0LuvMw/s4
xidTffjlnjblOZ+ssLo0h8/iLI1LdJuweAqlFn26DPRDLPL40TV0a6cvWyCrN41x
nXCEDL4Zbx6lnJ4BruQl
=Uhnw
-----END PGP SIGNATURE-----

--nYySOmuH/HDX6pKp--
