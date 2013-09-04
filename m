Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173Ab3IDSxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:53:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42130 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab3IDSxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:53:34 -0400
Date: Wed, 4 Sep 2013 19:53:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, ldewangan@nvidia.com, magi@slimlogic.co.uk,
        gg@slimlogic.co.uk, mike@compulab.co.il, anilkumar@ti.com,
        vbyravarasu@nvidia.com
Message-ID: <20130904185329.GY3084@sirena.org.uk>
References: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="70fLfmUGd5x0AJTB"
Content-Disposition: inline
In-Reply-To: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/10] regulator: tps51632: Use devm_regulator_register
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--70fLfmUGd5x0AJTB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 04, 2013 at 05:17:44PM +0530, Sachin Kamat wrote:
> devm_* simplifies the code.

Applied all, thanks.

--70fLfmUGd5x0AJTB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJ4GmAAoJELSic+t+oim9sN0P/jMNIiDYk5ASHwUU/Nily899
ZwwEEacySH/5K+3dXgKqVB3IhI35QnUJ2Jjs52pfjXDVJk4knEtgNbsGHFS5bd/J
QHk4jMWJ/X8bDMZdhxVLEwe4J1yQDcidH6koPRq9wG/A8iufi9SY78Cz0JmGjQvs
qoJqvNYAhhfx/1i3rmnJqG6ptWSIGrA+c5WGihhJ9qWvMZyr78b9B2+zRrsyI9Xk
/kn8ScnJQws/w6gKpGYwTWke6LFfVQzzTvMkQZoT03or3b1FlOjOHEgnMb3lNaLg
vbkMREQcx2B1D2ZKAmqcPjLEiq4nNsrrEVLmwDJY678VD7Iczys/NHsyjRAS+UsC
LDYI1NqIxAdZ9Za1Z9poqzIvRbq+CmuT1cnQjTsGvGF/Mx4cMTnCs/Q7ujAr80bT
3MPOrQsWKpYhCpVbHL6PONhWosxY9f9Oush6Vmo3XJZFq/olGIRBEk0kDn15foLg
2gfdQmzHUXQYERwOy1FcD1ZhBzt+/guulWjXIkAZa/QwwrCkr1MPtqvfb/5F1IyO
1oCsaFaN5GDGK3oFR5uzr5f2HspfdMyKA8bLwFSo/S14P9lhNULDcM3nI1qcxQXX
ysLcZsmw52mNgiABb1FwoEu9kcWQ56W4azdvfIKg1guz4Rtn7kh868f5UT+aDA/i
vm53qzA8gGDEzFflzsK+
=ahuk
-----END PGP SIGNATURE-----

--70fLfmUGd5x0AJTB--
