Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751083AbaKXVdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:33:25 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:64335 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaKXVdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:33:24 -0500
Date: Mon, 24 Nov 2014 17:25:08 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Rui Zhang <rui.zhang@intel.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] thermal-soc updates for v3.18-rc7
Message-ID: <20141124212506.GA1685@developer>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hello Rui,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.=
git fixes

to receive thermal-soc updates for v3.18-rc7 with top-most

d3e19567fa85e1a0dab02205b89b2908084ecadd:

  thermal: Exynos: Deletion of unnecessary checks before two function calls=
 (2014-11-21 15:20:17 -0400)

on top of commit fc14f9c1272f62c3e8d01300f52467c0d9af50f9:

  Linux 3.18-rc5 (2014-11-16 16:36:20 -0800)

Specifics:

In this -rc still very minor changes:
 - Lee Jones fixes compilation warning in sti thermal driver;
 - Marjus Elfring removes unnecessary checks in exynos thermal driver
   (as per coccinelle); and
 - Now we always update cpufreq policies, and thus get (hopefully) always i=
n sync with cpufreq,
   thanks to Yadwinder.=20

BR,

Eduardo Valentin

----------------------------------------------------------------
Lee Jones (1):
      thermal: sti: Ignore suspend/resume functions when !PM_SLEEP

Markus Elfring (1):
      thermal: Exynos: Deletion of unnecessary checks before two function c=
alls

Yadwinder Singh Brar (1):
      thermal: cpu_cooling: Update always cpufreq policy with thermal const=
raints

 drivers/thermal/cpu_cooling.c                   | 37 ++++++++++++++-------=
----
 drivers/thermal/samsung/exynos_thermal_common.c |  9 ++----
 drivers/thermal/st/st_thermal.c                 |  3 ++
 3 files changed, 27 insertions(+), 22 deletions(-)

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUc6IqAAoJEMLUO4d9pOJW3v4IAI2MfS9q+drdYAhAnNCoSLOr
CPdkbQiGuXlju+Cpu798sp6osAwbZQWYwWZNMwjznXO6M6JNAoYgW1hljAto0KZR
P6pxVnr48LIT5HxhdAChB09YWn+25RAFbRqmbX7PTlNx+LkmZexcDxSprozI35jO
yBbks46ycFSvM1MfIRT5LAkwiST8j2NYIb7OM39zEjKL5ZIcrbDskPKrEKBiIeye
98Uf5c+d1RBntIaw242NdaLggY3k8IzzBkzubUoxdExM050IrPvPcHCZJ57R8ltw
/hrh0vNRVGe43q4VnoiTGtXOXzEyAOzg7k8RpyYc0Cu/2ymtalHjMqFS9qfd6VY=
=kwn7
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
