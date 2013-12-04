Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab3LDOad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:30:33 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52648 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab3LDOaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:30:30 -0500
Date: Wed, 4 Dec 2013 14:29:54 +0000
From: Mark Brown <broonie@kernel.org>
To: Stefan Agner <stefan@agner.ch>
Cc: swarren@wwwdotorg.org, thierry.reding@gmail.com, dev@lynxeye.de,
        lee.jones@linaro.org, lgirdwood@gmail.com,
        kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra-owner@vger.kernel.org
Message-ID: <20131204142954.GW29268@sirena.org.uk>
References: <cover.1386108712.git.stefan@agner.ch>
 <127fe07e18665f93aa8d7c03e03164f1a049ddb6.1386108712.git.stefan@agner.ch>
 <20131204121424.GN29268@sirena.org.uk>
 <0983a0fa016faa5674834afad4472413@agner.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pkBzO0lo80FoaZii"
Content-Disposition: inline
In-Reply-To: <0983a0fa016faa5674834afad4472413@agner.ch>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 2/3] regulator: tps6586x: add and use correct voltage
 table
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pkBzO0lo80FoaZii
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 04, 2013 at 03:17:59PM +0100, Stefan Agner wrote:
> Am 2013-12-04 13:14, schrieb Mark Brown:

> > Acked-by: Mark Brown <broonie@linaro.org>

> > I won't apply since I think that patch 3 needs to go along with this,
> > unless people decide the regulator tree is the easiest way to merge.

> I merged the dependent DT changes into that patch, so from my side,
> patch 3 don't needs to go along with this...

OK, though now I look I see it also depends on patch 1 itself so at
least those two will need to go together.

--pkBzO0lo80FoaZii
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnzxfAAoJELSic+t+oim9TaMP/110TNKCQcPjLEzwc4W7nDso
XawviW5KcVx+RJjeXnQJ6K9mZaZFVu+1ZKMPeZpkpWEGH4OThf2VvZXWMcVAMyJ6
Zu1fZIh3j1imSn29iMgTmT7sKL8InInckhczTQ6wW3ZXT8IKJquBxKm/UzWzEgiK
pxpNV++eJjAHBAmjIPn1/0cFh5z/vHNSfdu/1pFtUt56hLmDsaX8tuCLtjkwb952
4m6CVrM7EyeVlo1EjugxmfvGVX1V+2OpkuqnIUdvUbbSZhgu9QHfj7oCVQaDbASN
BtQci+zTiiGbmysnQzahO4BTPfhBuoqtvyZM3irro2dggz7I2SsBbqmumG2M/tj/
1EznhdAa1fSUt8AFpTmHIFVGw/+WtgbFC02mUG8nH4jhIZId1faefusOg8j1oDPQ
IabTjzYzv7JymXjkLmmIC5dXKKpF4gtytULaPXfIMpwjS3iilIi3+DTnpmpc0SW8
59oFBwVS7CMQO1ndaLsLqfUsXBSKqM8/2Sz1QH+nO7gy3zMBDV1bFAXHxfvntd0F
FpLlROKL3jcEoKTRNWOskSqugb+tZPtzF4fkilVJZhNdmLYpGWvdaEyOe78Mcaby
YmX7IUkZbcAK4JmxYMyLPCxvDLj/HeO9gJWioR/VN7iZyP31hIdgI3nwn5h8UJOS
sCHXH++bTw0698hciDhg
=ZFul
-----END PGP SIGNATURE-----

--pkBzO0lo80FoaZii--
