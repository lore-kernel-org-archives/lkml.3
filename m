Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaJ0Tx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:53:59 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:57627 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbaJ0Tx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:53:57 -0400
Date: Mon, 27 Oct 2014 15:53:48 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] thermal-soc changes
Message-ID: <20141027195346.GB6088@developer>
References: <20141021134941.GA4937@developer>
 <1414041345.2380.3.camel@rzhang1-toshiba>
 <20141023112721.GA5683@developer>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <20141023112721.GA5683@developer>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Rui,

On Thu, Oct 23, 2014 at 07:27:24AM -0400, Eduardo Valentin wrote:
> Hello Rui,
>=20
> On Thu, Oct 23, 2014 at 01:15:45PM +0800, Zhang Rui wrote:
> > On =E4=BA=8C, 2014-10-21 at 09:49 -0400, Eduardo Valentin wrote:
> > > Hello Rui,
> > >=20
> > > Here are a couple of changes that are in my tree. They include:
> > > - a few code refactoring improving the Exynos code base;
> > > - new feature on the Exynos code base (TRIMINFO and TRIMRELOAD);
> > > - a documentation of RCAR thermal; and
> > > - a fix in the of-thermal, regarding the proper usage of of APIs.
> > >=20
> > what's their target?
> > please send me separate pull requests for different targets.
> >=20
>=20
> All are for 3.18, I forgot to mention.=20

Any updates?

>=20
> BR,
>=20
> Eduardo Valentin
>=20
> > thanks,
> > rui
> > > They are based on your next branch.
> > >=20
> > > BR,
> > >=20
> > > Eduardo Valentin
> > >=20
> > > The following changes since commit 6ceaf58abe25e86292152005c51169796b=
ad3407:
> > >=20
> > >   Merge branch 'int340x-thermal' of .git into next (2014-10-17 14:30:=
58 +0800)
> > >=20
> > > are available in the git repository at:
> > >=20
> > >=20
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-th=
ermal.git next
> > >=20
> > > for you to fetch changes up to df67e40f51398fef8dd705dfe4e287ad9b10ba=
4b:
> > >=20
> > >   thermal: fix multiple disbalanced device node counters (2014-10-21 =
08:05:50 -0400)
> > >=20
> > > ----------------------------------------------------------------
> > > Bartlomiej Zolnierkiewicz (9):
> > >       thermal: exynos: remove unused struct exynos_tmu_registers entr=
ies
> > >       thermal: exynos: remove dead code for HW_MODE calibration
> > >       thermal: exynos: remove redundant pdata checks from exynos_tmu_=
initialize()
> > >       thermal: exynos: remove redundant threshold_code checks from ex=
ynos_tmu_initialize()
> > >       thermal: exynos: simplify temp_to_code() and code_to_temp()
> > >       thermal: exynos: cache non_hw_trigger_levels in pdata
> > >       thermal: exynos: remove redundant pdata checks from exynos_tmu_=
control()
> > >       thermal: exynos: remove identical values from exynos*_tmu_regis=
ters structures
> > >       thermal: samsung: Exynos5260 and Exynos5420 should not use TRIM=
_RELOAD flag
> > >=20
> > > Chanwoo Choi (2):
> > >       thermal: exynos: Add support for many TRIMINFO_CTRL registers
> > >       thermal: exynos: Add support for TRIM_RELOAD feature at Exynos3=
250
> > >=20
> > > Geert Uytterhoeven (1):
> > >       thermal: rcar: Add binding docs for new R-Car Gen2 SoCs
> > >=20
> > > Vladimir Zapolskiy (1):
> > >       thermal: fix multiple disbalanced device node counters
> > >=20
> > >  .../devicetree/bindings/thermal/rcar-thermal.txt   |   5 +-
> > >  drivers/thermal/of-thermal.c                       |  40 ++++--
> > >  drivers/thermal/samsung/exynos_thermal_common.h    |   2 +-
> > >  drivers/thermal/samsung/exynos_tmu.c               | 141 ++++++-----=
----------
> > >  drivers/thermal/samsung/exynos_tmu.h               |  81 ++----------
> > >  drivers/thermal/samsung/exynos_tmu_data.c          |  83 ++++--------
> > >  drivers/thermal/samsung/exynos_tmu_data.h          |  39 +-----
> > >  7 files changed, 111 insertions(+), 280 deletions(-)
> >=20
> >=20



--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUTqK6AAoJEMLUO4d9pOJWJFkIAJ/Mxg7eVbOfAEJsBX8MsEzc
DMIQgsge0vRMXvUFp3dM9gMiy/QkFfWaQ3Z4yBEtZaTGFwZvXIqgKCrSdghg8X+k
Z9MyukzZ4KNQxreHeo0PwkJ3EckfE7VwWDkMyrz6mNfv0ECCDUlpJzoO8uGeFtR1
qmWi8j7cw++h76xttz1J+oYrZ49qSr24+7gTtuEUr5ZNA9kO8sYT468OmUyhEVEI
dhkW+LHNouEtDH5DC7bzxA34bmKVoHvmH5rCDoslatJkq5AQhUTM+vG/XaKCTflc
xFRjzrMDJ2CcRHBqSY/pW+cYAqCXWiB8xyyJcDnI5GqBd+2rxeChm3XS8uHQKgo=
=iaTF
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
