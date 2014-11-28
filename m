Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaK1RTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 12:19:06 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:37773 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaK1RTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 12:19:04 -0500
Date: Fri, 28 Nov 2014 11:13:06 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Rui Zhang <rui.zhang@intel.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [GIT PULL] thermal changes for v3.18-rc7
Message-ID: <20141128151304.GB24720@developer>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Linus,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.=
git fixes

to receive thermal updates for v3.18-rc7 with top-most

d3e19567fa85e1a0dab02205b89b2908084ecadd:

  thermal: Exynos: Deletion of unnecessary checks before two function calls=
 (2014-11-21 15:20:17 -0400)

on top of commit fc14f9c1272f62c3e8d01300f52467c0d9af50f9:

  Linux 3.18-rc5 (2014-11-16 16:36:20 -0800)

Specifics:

=2E By now I expected Rui to be back already. However, he is still away
http://marc.info/?l=3Dlinux-pm&m=3D141701567112573&w=3D2

He might still be sorting things out on his side. Therefore, I am
redirecting this pull to Linus.

=2E In this -rc still very minor changes:
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

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUeJDyAAoJEMLUO4d9pOJWW4cH/Rczgz9vecWZFA97vo0kQxOY
UhEUvM8K1xYLbqRi23AVafgORTTkJGQzHt+C3ACB4dU7doISagflSFYJC1436rVV
R7cgjh2Z5LPcw3RH8kwhHnLA/JqGrcaepy3fCfrUAaVenMWokiT4O1oFsLoNvTLc
KR1cwNjfHl8AFPKLMJ30q4hA0aZtx2ZZ9JQaenKJbxYiNQmN3CHrM/zWdWtnFJsf
Gpr1KJ0DO3sVC4P24Vvk4KFE0S3+ru9hTorlz1oJLelH/eHlVLGHGioww+szNn4B
vcUGDinpGiafjUoeOk14ogCnmWBJbh8FOqxp3ss+Nzq6uRlQxUqqq7MyCAhZZXk=
=D3kU
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
