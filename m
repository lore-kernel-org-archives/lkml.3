Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229Ab3CLSRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:17:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55738 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932456Ab3CLSRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:17:32 -0400
Date: Tue, 12 Mar 2013 18:17:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, zonque@gmail.com,
        yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] ASoC: tas5086: use module_i2c_driver to simplify
 the code
Message-ID: <20130312181729.GC19942@opensource.wolfsonmicro.com>
References: <CAPgLHd_J+xdx6UdSFahEGmPJX-SXEkQBL7xHA7MEGKf21=32Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1ccMZA6j1vT5UqiK"
Content-Disposition: inline
In-Reply-To: <CAPgLHd_J+xdx6UdSFahEGmPJX-SXEkQBL7xHA7MEGKf21=32Uw@mail.gmail.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1ccMZA6j1vT5UqiK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 12, 2013 at 09:36:24PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Use the module_i2c_driver() macro to make the code smaller
> and a bit simpler.

Applied, thanks.

--1ccMZA6j1vT5UqiK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRP3EzAAoJELSic+t+oim9gQkQAIh5mymwNCFCWXqCILfcWpZk
ji+8kCuTU63tfewuVEaiv0tq0hFbtpPEFaDP5r0TqSpw/R6XeynVuhFEuleX3SWj
qayrwDwlat5SX1RFIgxuKlpnYpoAQ2HA5sDWeKzr7ZlNm2+FZJmKs0caEmibLBNS
d7QwhUzCCW3D6nG2SFg4D3yfCDDOuMeiFOjt3rh2y1r6zT6uY6aITt845vxbTuq5
LtL2rJQCeTN1HiAysk3GnVd91D1FFPW0NiJ7L/HyQf6385h+wZxy1n1zGUnRDHrW
SarSzPAto8rMqSY/bD8Yh+MiUl5fYv2IamUy8KlESYISPhnT33DXmwp4pC68Y2KW
/oH4FfwbMsb7ZBsN0R5SI/KMM2pDXsRE5MXYAl8Ty4xXcLRyEDtwO1792tO60wrd
N8KEfls3vAcIuZ4FecqtTWwut1CwqWeXXTe9gQQRHSNBkf64RirhQE2p7iKGIHAH
13CI1hGj3/m27QcBEd+vxC89uFH6S/R6+DRAeDdmDsasOF4GUxC9JIBCiaElb3qI
TbYLggHQBYCkuawAiTk1fYn5/AfNar3GSMPEyUE/Uy296UwdDCrjlMhDet9SEnE6
W3nkjxXdMehb9m5ZLehEsjTG2GCTQVfzhUgQMVE0Xpo7hJFAwt+84iR3sY8Wsqyg
x+MsplbYOOpU6mHK78ow
=/tqE
-----END PGP SIGNATURE-----

--1ccMZA6j1vT5UqiK--
