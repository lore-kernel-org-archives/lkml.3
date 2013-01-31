Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3AaK0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:26:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39532 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752941Ab3AaK0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:26:40 -0500
Date: Thu, 31 Jan 2013 18:26:29 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Brian Lilly <brian@crystalfontz.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: spi-gpio: fix compilation warning on 64 bits systems
Message-ID: <20130131102626.GC11078@opensource.wolfsonmicro.com>
References: <1359627176-22706-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kVXhAStRUZ/+rrGn"
Content-Disposition: inline
In-Reply-To: <1359627176-22706-1-git-send-email-maxime.ripard@free-electrons.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kVXhAStRUZ/+rrGn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 31, 2013 at 11:12:56AM +0100, Maxime Ripard wrote:
> SPI_GPIO_NO_MOSI and SPI_GPIO_NO_MISO flags are type casted to unsigned
> long, yet, they are to be stored in an unsigned int field in the
> spi_gpio_platform_data structure.

Applied, thanks.

--kVXhAStRUZ/+rrGn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRCkbLAAoJELSic+t+oim94joP/A7CJ99nrjA7PLqE8WfXIbLG
cp0Iu9nXfGZ79WrG661hJWA6WBhdWwd3gcmJLOC8Zi2HlcdxSX3fewwWqWCXkaDU
tGgFLrbk4mU7YJD28HJuJSRB+Shc8n+b93ler08YFLUI9e4b3OAQT8fgi1kkrkyI
T2cOjLhIsS2YzfVxKIY/kBfXTHOy+D5o2TgxwSVsfWbHfhFobMgd5rGhqNgtCMQK
zdvPWKlR6g0tezUhOWcb4Hz1JFWjeMKnpZ28egaSjE0uclO3lrImfouRYAXP71Wi
efs/Df+fROflu3Eqa+4OZs+702memFr6icx940In9JMCun1q4Xv5LQUDAibOewmZ
C66GXi71uO44JwyVkVBtXH0Cen6KOiVG8V/638p614Vo/0zxGhsNRl0r/kKDCri/
K7eVBlx3ZYELYI6/vL1ZFgOCMBah9jy34q42L5/opsLMH+GYED11pungxIoKSGUj
zUeqRb0CvPxxRmhiydZ+Ch0Dj3E49hmkqahi55lXY43uAdp9F8FRS3URh3qWbrcP
y5upCKyBoP5/PQSQgfjGsbrwfyQNJpcvvEWHFumCKl3i/mZlBTGvQei6+kWGf9Oc
8rSzZXAcS66cJHfq0GRvwgKvlDHV1jHDvd95wXu0ZUGu+9iBawMbWnVI9QfR0QJ0
CSrI/wrNpkV474zJ4Ygn
=lQsy
-----END PGP SIGNATURE-----

--kVXhAStRUZ/+rrGn--
