Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673Ab3EGNzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:55:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49017 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821Ab3EGNzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:55:04 -0400
Date: Tue, 7 May 2013 14:54:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        yongjun_wei@trendmicro.com.cn, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20130507135431.GT7478@sirena.org.uk>
References: <CAPgLHd-5rAbUnijs_dfeXuk9LhsSKihOBYeicLWDvZECfP0LmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0WGqsT62A4RTsSXf"
Content-Disposition: inline
In-Reply-To: <CAPgLHd-5rAbUnijs_dfeXuk9LhsSKihOBYeicLWDvZECfP0LmA@mail.gmail.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: wm0010: fix error return code in wm0010_boot()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0WGqsT62A4RTsSXf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 07, 2013 at 07:38:52PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Fix to return -ENOMEM in the memory malloc of 'out' and 'img_swap' error
> handling case instead of 0, as done elsewhere in this function.

Applied, thanks.  Please note my new e-mail address.

--0WGqsT62A4RTsSXf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRiQeUAAoJELSic+t+oim9M3AP/RgCrVYDfwHqOvHUQ0qn/E5r
AwA8nIaCnpuIoPUMzTi/KHhuw20XI5exuNKMmr4D2AsJVoo/ayVGaOq+Urs7ytmR
bS6fDmX8xi01ZB6vCvrSYr3aKDL6sqR+avqi5JEj070C7+ZolDkq8lKVKggj4YMp
Ty7u0/moLgWI64t+YeRIBivUHyxqESfpBAXEKMMhw3t1ENnu28IZOwL9Sbh+R4Kv
OUc7RU8q27+4uR3G6KpZNRxXfycVWzym1d1rnEEFLeUBRBtQEiNnmOCoNWDs4JQ3
Sj36Ssvt0yjjzk3+uVCKUtIsn8kwg6IQ5DwvIbkhL3aIKGXC/QqQvJnD5VOVMj7I
fgEzuFbevohrRa1GBw3+N2cXFItSBig3RjXS2rjp+7fa2mD6OkW8/woHD+CuoJDz
AiYTWcADRSGat3uH/zXzDYJNgluEilk9TaPJSdWDyuNO1iP1QB1HLLSOa2suNqZt
D+YyH9OV35ejQsVxykdzhHD0K6LRDz7DNQYJzKQXMdD13W62QnpYh9UQ+li/HDmY
xi6QQT3q+xava6K5U6gcVNqU7281+32kAeRWoZHqPzeovSKZMI67I2vcAXFfNAy6
6Okc0KdrqaEW+yP+CzB8JnqubyHs3fU8iy4KvXaXFpntLHuMFV4cb7Dg2c4Zzjlq
lRBVRdkMT9s4GcCtLN2S
=/TCp
-----END PGP SIGNATURE-----

--0WGqsT62A4RTsSXf--
