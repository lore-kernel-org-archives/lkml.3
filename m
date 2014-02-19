Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbaBSQ2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:28:04 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55313 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbaBSQ2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:28:02 -0500
Date: Thu, 20 Feb 2014 01:27:44 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140219162744.GO2669@sirena.org.uk>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
 <1392720071-13503-6-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YrHeAUbOAX9OMs3W"
Content-Disposition: inline
In-Reply-To: <1392720071-13503-6-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 06/15] regulator: lp872x: Do not hardcode return values
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YrHeAUbOAX9OMs3W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 04:11:02PM +0530, Sachin Kamat wrote:
> Propagate the error values returned by the function instead.

Applied, thanks.

--YrHeAUbOAX9OMs3W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBNt8AAoJELSic+t+oim985YP/2dhv1CLx6nK+v3db+YKn4q0
kYOqC+M5PSVa5krx/sXxC1jYEEL7Sn4KUn0QOqmtTuhsXmcPwWkshROuxQU5vADk
Rp7TXVhSymo0dJ1dQI9FtWsl90u8D9MSLNKBlboYTCw869/AgNwuiVi1HHNo1JYO
OX0L0LROrMpKgvUUFcuVzFLnFrxk4Nk2psTesjErR2t2zaeIj96DoXj0akREDYfb
u42UduMDxFnWsH63koXFHXa6iUyJVel0qwLbXkdV/zMvrln4H6Mpfkxx+GcfNRIG
UUTN7akgUiBXMBfm3QFA23mbPKLwdg+h6vgEZsKsKA3S2YOg5Zgfr2K5vUqdok3t
WAB1xEzeYKiOC7J66a6S70a3nEkXNbhpIuEJ6DHcRbzlKLV1SyW1K0xIYjqEKwKJ
BG7ueWUYKroSvasRXlPH+eaSC2snj6k402BWlv4XuWfaI/5ioERXOLqzHacvedgM
tCu/sv5MGDQqAW6ZvJGH3zd3oJpwHcCTg67tO37/PxDYB3F5eBQgr0lsa7205Fps
AMWGWcAW1FRWu+yELORmWl69uPYaJvUB7ZelAyqvuwNBRn7D+3pOMUMIL8QCXeFA
ULzFEwd6R0wzRtUoBXi70mndbzEp9m0DP/Tu7z52eE1aqcjHcwtGWL4D5Tm8ik9Q
bYowk8YlwiIBAKNX65lq
=85xg
-----END PGP SIGNATURE-----

--YrHeAUbOAX9OMs3W--
