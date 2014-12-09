Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbaLIB3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 20:29:47 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:35541 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbaLIB3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 20:29:44 -0500
Date: Mon, 8 Dec 2014 21:21:05 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Linux PM list <linux-pm@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Caesar Wang <caesar.wang@rock-chips.com>,
        navneet kumar <navneetk@nvidia.com>
Subject: Re: [PATCH v3 0/5] thermal: of: of-thermal.c API extensions
Message-ID: <20141209012103.GA22004@developer>
References: <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
 <1418058261-25251-1-git-send-email-l.majewski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <1418058261-25251-1-git-send-email-l.majewski@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 08, 2014 at 06:04:16PM +0100, Lukasz Majewski wrote:
> Provided patch series extend of-thermal.c file API. It is necessary=20
> for ongoing Exynos TMU rework.
>=20
> First version of this code can be found at:
> http://www.spinics.net/lists/linux-samsung-soc/msg37719.html
>=20
> Second version:
> http://www.spinics.net/lists/kernel/msg1872274.html
>=20
> This code provides methods to access some of-thermal local data.
> Moreover it provides a read only access to of-thermal trip points.
>=20
> Lukasz Majewski (5):
>   thermal: of: Extend of-thermal.c to provide number of trip points
>   thermal: of: Extend of-thermal.c to provide check if trip point is
>     valid
>   thermal: of: Rename struct __thermal_trip to struct thermal_trip
>   thermal: of: Extend of-thermal to export table of trip points
>   thermal: of: Extend current of-thermal.c code to allow setting
>     emulated temp

Applied the series in my -linus branch.

Cheers

>=20
>  drivers/thermal/of-thermal.c   | 109 ++++++++++++++++++++++++++++++++++-=
------
>  drivers/thermal/thermal_core.h |  18 +++++++
>  include/linux/thermal.h        |  18 +++++++
>  3 files changed, 127 insertions(+), 18 deletions(-)
>=20
> --=20
> 2.0.0.rc2
>=20

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUhk52AAoJEMLUO4d9pOJW72IH/2HrY/qq1YM135SR31Qinko4
ycKuClzqp3VY2Iz/WnOa3ZR8WOY/IeqFdP0shY7tUhKAWomP6+g/iuHWe/J2cFa1
RoN3OP1R8LmwKI0rSHTHzdsS9r2IkqeFIzfxNUfNCW6a8hAhpXWcXnBTd+Ql8KVk
laB21nfnHerlvh2fzz4FrEBWqyso4t2o0o/n49kJyFWWrv+/6c9OBWJvRjvwqjoN
2Y/L9Y3sgP7feI/AnLuX4G2K/cAmV8wOdPYmuu6HRl4IlmwD5j+TfAffLQQN1Syq
cLa5XAzZ8HFaui6wfKcsy6OQz23P2uJwG/e67m7RPeu8W7kQ1jWmErxzyj69UZA=
=fxLy
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
