Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaLCLWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:22:37 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46972 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaLCLWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:22:36 -0500
Date: Wed, 3 Dec 2014 11:22:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-spi@vger.kernel.org, pantelis.antoniou@konsulko.com,
        grant.likely@linaro.org, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com
Message-ID: <20141203112213.GV7712@sirena.org.uk>
References: <alpine.DEB.2.02.1412022041580.16734@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PRH0fqouaz6lm1TV"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1412022041580.16734@utopia.booyaka.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/of: fix warning due to missing CONFIG_OF_DYNAMIC
 dependency
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PRH0fqouaz6lm1TV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 02, 2014 at 08:46:28PM +0000, Paul Walmsley wrote:
>=20
> linux-next commit ce79d54ae447d65117303ca9f61ffe9dcbc2465d ("spi/of: Add =
OF
> notifier handler") is causing the following warning during boot:

Someone already sent a patch for this (think it might have been
Fengguang).  I'm hoping Grant's going to apply it, I can't since the
code is in the DT tree.

--PRH0fqouaz6lm1TV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUfvJkAAoJECTWi3JdVIfQ31gH/0SM17cqZHq3nR+UFwO3a6jh
xXyPOMCM9igiz8aWSwqET1AmChwGD7a+K2MNF3GD5p9kVnQ+TwNIZtQF/qBycxiY
bsFUB5M+mv5o8VRERB/v/10gK/vYS4XtOnU0L2TrtabIAal2FswKd61mq6GGP1Je
S8b08by7DlnFES+713nx4+4WA7j6SuQBf2MsREJ9q5KZSpkLltUXKaSN26elopyR
4dui63o+0/3IFkSUv0tfQaAvXkGJ/l+PweHMsTKcaMvIgm9OH+Onsi9pHaX+++RO
cfIpyFXOvZ6Qxyb5MFz/4vdwm7/9CADD01CWU4f6u3tKl5Yp7Em+m/5oSAdJPts=
=GnU2
-----END PGP SIGNATURE-----

--PRH0fqouaz6lm1TV--
