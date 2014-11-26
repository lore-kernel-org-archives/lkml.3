Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbaKZP1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:27:49 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:54044 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaKZP1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:27:47 -0500
Date: Wed, 26 Nov 2014 11:27:38 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Rui Zhang <rui.zhang@intel.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] thermal-soc updates for v3.18-rc7
Message-ID: <20141126152736.GD3925@developer>
References: <20141124212506.GA1685@developer>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g7w8+K/95kPelPD2"
Content-Disposition: inline
In-Reply-To: <20141124212506.GA1685@developer>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--g7w8+K/95kPelPD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Rui,


On Mon, Nov 24, 2014 at 05:25:06PM -0400, Eduardo Valentin wrote:
>=20
> Hello Rui,
>=20
> Please pull from
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-therma=
l.git fixes
>=20


Have you had the time to have a look in this pull request? I am not sure
if you got your environment working yet.

> to receive thermal-soc updates for v3.18-rc7 with top-most
>=20
> d3e19567fa85e1a0dab02205b89b2908084ecadd:
>=20
>   thermal: Exynos: Deletion of unnecessary checks before two function cal=
ls (2014-11-21 15:20:17 -0400)
>=20
> on top of commit fc14f9c1272f62c3e8d01300f52467c0d9af50f9:
>=20
>   Linux 3.18-rc5 (2014-11-16 16:36:20 -0800)
>=20
> Specifics:
>=20
> In this -rc still very minor changes:
>  - Lee Jones fixes compilation warning in sti thermal driver;
>  - Marjus Elfring removes unnecessary checks in exynos thermal driver
>    (as per coccinelle); and
>  - Now we always update cpufreq policies, and thus get (hopefully) always=
 in sync with cpufreq,
>    thanks to Yadwinder.=20
>=20
> BR,
>=20
> Eduardo Valentin
>=20
> ----------------------------------------------------------------
> Lee Jones (1):
>       thermal: sti: Ignore suspend/resume functions when !PM_SLEEP
>=20
> Markus Elfring (1):
>       thermal: Exynos: Deletion of unnecessary checks before two function=
 calls
>=20
> Yadwinder Singh Brar (1):
>       thermal: cpu_cooling: Update always cpufreq policy with thermal con=
straints
>=20
>  drivers/thermal/cpu_cooling.c                   | 37 ++++++++++++++-----=
------
>  drivers/thermal/samsung/exynos_thermal_common.c |  9 ++----
>  drivers/thermal/st/st_thermal.c                 |  3 ++
>  3 files changed, 27 insertions(+), 22 deletions(-)



--g7w8+K/95kPelPD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdfFfAAoJEMLUO4d9pOJWk3wIAJ4i5/yjOUCa/kNLLcMFAdAB
nXlh3QeZAcG9xhmVkbuxEKHVpoMjha+QLCQMfHSoF6pc8TXAGbLxGyqYQ5qqNkY6
9AICoxmCbtXd7QoZrfqaDufZGsIdnUMgZdN4HgocdOEg0McmTvXMkLlhvCdZgY17
7AW1/QBC94TckuhlgvMOyFfhy6jrgCSQtYyH5PpvcBb3QK+TGt0mt7o04LZTi+DQ
oRSTPI9h0ZP1RV27HIAHh8RmPOKTCtmgcNUsY1Fquij1V1PrUtSytarN8HiPHxm2
2VQp8y00QibiF4NHh2LR4SgPQnAhE0XqgW7ebDVK1FcOJi0so8h43xF7G9ciM5c=
=DYM+
-----END PGP SIGNATURE-----

--g7w8+K/95kPelPD2--
