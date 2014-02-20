Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbaBTKzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:55:13 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47196 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbaBTKzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:55:10 -0500
Date: Thu, 20 Feb 2014 19:54:48 +0900
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Message-ID: <20140220105448.GS2669@sirena.org.uk>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1392736948-26623-18-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0iSpYRf9rOurbk0+"
Content-Disposition: inline
In-Reply-To: <1392736948-26623-18-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 17/17 v2] ASoC: pxa: tosa: Update locking around use of
 DAPM pin API
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0iSpYRf9rOurbk0+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 03:22:28PM +0000, Charles Keepax wrote:
> The pin updates in this driver look like they are intended to be done
> atomically, update to do so.

Applied, thanks.

--0iSpYRf9rOurbk0+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBd70AAoJELSic+t+oim9978QAJLH6BZBfVw9/VCLbTJs2PSk
Jxnw5SSHkwLE5LIBjjSIbsbeiW5MvN0r1DKkXsDlS1l0IhSRydZ9/tbjCupzLtnj
lGan/DIsYFFo7fPGf7+LB8K7zKZLOwREt8laCLxvJVotmTIMGzeXFSQxTyBlQmGa
m1vkIOjNpeZhkVOzQCO3ISjc4F4e37ZFmbK5qMa5KW5jbDERYbKXR2Y/WJ6+Pyg/
NVfPZbRybo4pY52cvji3GRbWo8oTDo6anh08Nr6gcLCbq0q52TQwI//jAjaAw4rQ
11UL3fQQ4TkuEmRIp1ya+hs/J3LXa8Z6FqVF9Y7FNBSX17wciFiL7LCSUxUYNXpj
VZde/z0GXh0TgfYgtIjdbQwmvd/C7bcxOO9oFUS41Gex/AwIHBBdFbNq5NpdZSTJ
U5XLhhLcvPMBcSFGKi9zKGbcW5v1iN2UUhuuov0yYkGwBh/iYBSpUSZLpeKDF/R+
2+OuZMdyFrfRoKfW2uigN1M/8ZOOdkGAWtRftPrbUOAVPFbBgyOmpWLb+hid0i2S
GeaDpQqVM/u32Sd7Uk81yieuEkjXK+q6ZOQCWKn74vPn3pLKn9sN/6Sr7mJQR6CR
dDiITngAKFAK1Ou4fgttV79Isfod+h6XGhO6JvbNt/isgiZ8oUotI78P9OfnDtDR
QEEy6oCOIGnQ0gvoC4he
=J702
-----END PGP SIGNATURE-----

--0iSpYRf9rOurbk0+--
