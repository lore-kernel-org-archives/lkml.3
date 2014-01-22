Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbaAVTm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:42:58 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58306 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaAVTm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:42:57 -0500
Date: Wed, 22 Jan 2014 19:42:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com,
        Xiubo Li <Li.Xiubo@freescale.com>
Message-ID: <20140122194246.GY17314@sirena.org.uk>
References: <20140115113551.0eb13409@armhf>
 <20140115165148.2e0e19f3@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mnf9g033gFJG8dr6"
Content-Disposition: inline
In-Reply-To: <20140115165148.2e0e19f3@armhf>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 5/8] ASoC: simple-card: simplify code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mnf9g033gFJG8dr6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 15, 2014 at 04:51:48PM +0100, Jean-Francois Moine wrote:
> The CPU and CODEC DAI names are still copied to the user info structure.
> Put them directly in the DAI links.

Applied, thanks.

--mnf9g033gFJG8dr6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4B8yAAoJELSic+t+oim9X7AP/i1l7WM+mQagUXb++bO89Tsr
yF4jGPwYzzoGWSQVqqyqk+D/4fmsmqlut7JiD5RD5Ppmv8uXyKSnBuuONgligYG3
VeQSAv+/3Ioj8JXZUSG+n+Df1WHiSittHeMqU6g6jZSPlzk+Pf9PefyvOM0lb28x
2pFFrwerhRxOiW7+G8rVXFN4Q4aQJuwxCkkf+lGy5J/+Qgn5NO0iAXUbYn30N18n
fNPVJBMtsKIN5IzKd9vlCE24/Iq5/Gc8cEoXjzwFj78L6GU1rOpkxcTh0xq9bl2M
aRkJqG0T1ZXbyEohvCx6NW72ejBP8JeY/4PNU3MOaikugzmf3R14liTPws3gO/YK
xcDa3dStXoY5jpsg9MGXKj50sp97JRa8jqsmQNtZbjXw6KT4qGySrACT6bJWrhpD
33Z1jkPvwhCQrSRCTF7Bpcbhz5YMO2dUhJzPRYdHqsrDMMrvp3XC//S7aWEYWZjf
PykBrl8uZmOECZkFcLTvhAm3sa2A/V9MsU3kECsQOopLZyD2zoJ55f0PmJdSVe8a
wXTF6hOKZWVRKf0dUGg1k7dN3o80iE+rzTkV4V1n6FajN6YUgsS0uK2I6GJMdA+P
5qWWmIzbj7enJtg8NplFze9jJOyivY7uqAi0teM0OYSSNMAT6UbnhsfUmvw5ar2M
cKG2FdWJFxNsD7vc2Em4
=LAg8
-----END PGP SIGNATURE-----

--mnf9g033gFJG8dr6--
