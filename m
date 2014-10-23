Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbaJWL1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:27:30 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:59781 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbaJWL13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:27:29 -0400
Date: Thu, 23 Oct 2014 07:27:24 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] thermal-soc changes
Message-ID: <20141023112721.GA5683@developer>
References: <20141021134941.GA4937@developer>
 <1414041345.2380.3.camel@rzhang1-toshiba>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <1414041345.2380.3.camel@rzhang1-toshiba>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Rui,

On Thu, Oct 23, 2014 at 01:15:45PM +0800, Zhang Rui wrote:
> On =E4=BA=8C, 2014-10-21 at 09:49 -0400, Eduardo Valentin wrote:
> > Hello Rui,
> >=20
> > Here are a couple of changes that are in my tree. They include:
> > - a few code refactoring improving the Exynos code base;
> > - new feature on the Exynos code base (TRIMINFO and TRIMRELOAD);
> > - a documentation of RCAR thermal; and
> > - a fix in the of-thermal, regarding the proper usage of of APIs.
> >=20
> what's their target?
> please send me separate pull requests for different targets.
>=20

All are for 3.18, I forgot to mention.=20

BR,

Eduardo Valentin

> thanks,
> rui
> > They are based on your next branch.
> >=20
> > BR,
> >=20
> > Eduardo Valentin
> >=20
> > The following changes since commit 6ceaf58abe25e86292152005c51169796bad=
3407:
> >=20
> >   Merge branch 'int340x-thermal' of .git into next (2014-10-17 14:30:58=
 +0800)
> >=20
> > are available in the git repository at:
> >=20
> >=20
> >   git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-ther=
mal.git next
> >=20
> > for you to fetch changes up to df67e40f51398fef8dd705dfe4e287ad9b10ba4b:
> >=20
> >   thermal: fix multiple disbalanced device node counters (2014-10-21 08=
:05:50 -0400)
> >=20
> > ----------------------------------------------------------------
> > Bartlomiej Zolnierkiewicz (9):
> >       thermal: exynos: remove unused struct exynos_tmu_registers entries
> >       thermal: exynos: remove dead code for HW_MODE calibration
> >       thermal: exynos: remove redundant pdata checks from exynos_tmu_in=
itialize()
> >       thermal: exynos: remove redundant threshold_code checks from exyn=
os_tmu_initialize()
> >       thermal: exynos: simplify temp_to_code() and code_to_temp()
> >       thermal: exynos: cache non_hw_trigger_levels in pdata
> >       thermal: exynos: remove redundant pdata checks from exynos_tmu_co=
ntrol()
> >       thermal: exynos: remove identical values from exynos*_tmu_registe=
rs structures
> >       thermal: samsung: Exynos5260 and Exynos5420 should not use TRIM_R=
ELOAD flag
> >=20
> > Chanwoo Choi (2):
> >       thermal: exynos: Add support for many TRIMINFO_CTRL registers
> >       thermal: exynos: Add support for TRIM_RELOAD feature at Exynos3250
> >=20
> > Geert Uytterhoeven (1):
> >       thermal: rcar: Add binding docs for new R-Car Gen2 SoCs
> >=20
> > Vladimir Zapolskiy (1):
> >       thermal: fix multiple disbalanced device node counters
> >=20
> >  .../devicetree/bindings/thermal/rcar-thermal.txt   |   5 +-
> >  drivers/thermal/of-thermal.c                       |  40 ++++--
> >  drivers/thermal/samsung/exynos_thermal_common.h    |   2 +-
> >  drivers/thermal/samsung/exynos_tmu.c               | 141 ++++++-------=
--------
> >  drivers/thermal/samsung/exynos_tmu.h               |  81 ++----------
> >  drivers/thermal/samsung/exynos_tmu_data.c          |  83 ++++--------
> >  drivers/thermal/samsung/exynos_tmu_data.h          |  39 +-----
> >  7 files changed, 111 insertions(+), 280 deletions(-)
>=20
>=20

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUSOYOAAoJEMLUO4d9pOJWaKAIAIfJ7A6l+GfSJRRJLIXkidcX
dNVBb+DN7S2INDmWYRoKEcZ6Ins3vCDxVVxa6OxhPPEzsdH4wo57LqnCAatT3e3L
n+aZBQoGQsVtTaU1e2MSL1acLI7x5PTJ4arp64uGfoi6z0SkBICUr00hbnP5WQQD
FY0U3k/WHrR/4z3yWZAxkX5cPT4DbqsYK4EUzOcRmFPv4fM7kTwpGyLf+mTuambx
7vOWXpqeLwMLk6zp6nIiKpy9Oz8mDspv4H4203KHBB2+JG53QNkE+d32R+wJuK3H
UvyLyJpWk5uoWiVj9f85rfJQ/VfA2K1F4jep76D/3TW/ZwDT6eESPYeZDkSZKzM=
=s+zG
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
