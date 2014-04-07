Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaDGNJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 09:09:09 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44388 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbaDGNJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 09:09:07 -0400
Date: Mon, 7 Apr 2014 14:08:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140407130853.GG14763@sirena.org.uk>
References: <1396784733.30640.25.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q4EqwgQSYGfzam5l"
Content-Disposition: inline
In-Reply-To: <1396784733.30640.25.camel@x220>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: qup: Depend on ARCH_QCOM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--q4EqwgQSYGfzam5l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 06, 2014 at 01:45:33PM +0200, Paul Bolle wrote:
> Commit 8fc1b0f87d9f ("ARM: qcom: Split Qualcomm support into legacy and
> multiplatform") removed Kconfig symbol ARCH_MSM_DT. But that commit
> left one (optional) dependency on ARCH_MSM_DT untouched.
>=20
> Three Kconfig symbols used to depend on ARCH_MSM_DT: ARCH_MSM8X60,
> ARCH_MSM8960, and ARCH_MSM8974. These three symbols now depend on
> ARCH_QCOM. So it appears this driver needs to depend on ARCH_QCOM too.

You probably want to CC some of the Qualcomm people (or whoever made the
above change) who know what's going on with these symbols.

--q4EqwgQSYGfzam5l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTQqNiAAoJELSic+t+oim9pAkP/R+FZz7MOa/s/qcncjOXl8vQ
InmURnZlQ2dAvZzO6YROauTanH6WU9Xq+vWgPirprpgz+yqfAzLpYNMuPpbP3Wnc
nO84qc5PwPXzlO679LP/FUCsd8N/tSWTqr6ls0+7gGMyYshPhYNS9RIdhfxeqMnV
eghsWhEesyUxETDTQgDAj2E1VhkrfBLYvYIuL/fsKKwjt+WnyZKGVsNcXiDmLrGa
vj4yWP1CoFbDbuOEDrpx6j69MhuFuYzHeo0DETs/L1FmNkltpa+u5FnaZk7kb8wX
45/Bt/UX/+YI9NXRarDxBzpwozRo+hyDs6aAehl5N8Qa/7b6Tj0XuruwBYnO4Gj2
rzPTgi1Q/X5Kv/vpfqguDX+ku1pC6H9JQ07CbDwNtsRExwiv4RTGt1Z7/K9O8XqF
OGUNQJqL724mUYDqIrZnjH1RjtScRuTk6zKgaqZCzqkqaqfnPVELY+mAD6tiCb36
JxDojE8zaqZXsHhFaTbqpxpxQeTgZCtbFTuQoxH9hLhP4cxtFWzgpHusf9zDvJCB
Hdo55Da4aOh6GkTM+CfwXN202mKCBSJ+o5mGxZ5ZyBTg/f7Vv3Wk7SuQxBh1C8PC
5PnH9sk4RpEjnhtoGjswYYqsrtZOl9dByptkq1+e51h90ep5fKNmJCvteBM3H2bg
HCHKdXXjANQ7uk1fVDv7
=O1JK
-----END PGP SIGNATURE-----

--q4EqwgQSYGfzam5l--
