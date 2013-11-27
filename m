Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab3K0Qx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:53:59 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52018 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab3K0Qx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:53:58 -0500
Date: Wed, 27 Nov 2013 16:53:54 +0000
From: Mark Brown <broonie@kernel.org>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Fabio Estevam <festevam@gmail.com>, Liam Girdwood <lgirdwood@gmail.com>,
        thierry.reding@gmail.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Message-ID: <20131127165354.GL14725@sirena.org.uk>
References: <1385569457-8650-1-git-send-email-broonie@kernel.org>
 <1385569457-8650-2-git-send-email-broonie@kernel.org>
 <1385569979.32005.2.camel@linaro1.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wmb//eAa7gSNqSeK"
Content-Disposition: inline
In-Reply-To: <1385569979.32005.2.camel@linaro1.home>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: core: Check for DT every time we check
 full constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Wmb//eAa7gSNqSeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 27, 2013 at 04:32:59PM +0000, Jon Medhurst (Tixy) wrote:

> Doesn't this now make this code in regulator_init_complete()
> redundant..?

> 	if (of_have_populated_dt())
> 		has_full_constraints = true;

Yes, it is a bit redundant now.

> Or is keeping this to avoid one less variable check a worthwhile
> optimisation?

I expect it can be removed, I just wanted to check that the function
wasn't horribly expensive for some silly reason before I actually went
and did that.

--Wmb//eAa7gSNqSeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSliOfAAoJELSic+t+oim91HUP/RoMn/fJ5lA/UVUYFiyrZZul
UEkB0/B84FZl+idNgpotUa+ucQOneo/SO1vGmih33LeeMUK32mitALcgzKRTfw8N
NBy9yBR9RpDQMmU/bE0x+mw0vmE7CNuelK2/DG2YO42QQwM/b1zaemCByIb7UcEY
HafZ13Q91goisWJCxYkxuHKyOpz3R2PEaa2b+xFr+LApLnp0ugvhzWoRAJBXGl1l
lO48K8GYP+cNp3bQoUCxTRK7VsPsIMc2Zma7E58z34YV1XzeFvb6mjq6xnjGgmML
WPpGxDTJ4RfhjJ/WqPfNrP+EThPftOUbm6Lrug6J3FHw3Z/uauE6Iw12CkH8ldvb
sj2O1VPk/KLR9xsqIPbuFkvWPauinzD4BdwjiX9ibWfu8KzoRA4FPP0TShzOlN5t
pPthruzG823V6YjIf3xgYlKrcQkvkJep6eXMjgrlsZEhFbXSfM2qmDsoIfB3mf0W
4D6JvIb6tO5Zi9vjM+tK9sJ8o0y6dohppvs2q8uMPBSCntLXXfd/JlDlzBRslRSq
YgXnYXdS+K9Ii164hKH63VGRkiOSc8thjUnFaJKbCUGInICJOtjPmpIB0hF6jEP/
w4qLnvkBtiMRjdnSt3yAQ7hBfH+q6wausUsgMM5q0Dcro/JrOq8otzZKay4l3yh5
TQXbJGGixyr9aBgenows
=Saie
-----END PGP SIGNATURE-----

--Wmb//eAa7gSNqSeK--
