Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719Ab3CGCn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 21:43:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58088 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753454Ab3CGCn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 21:43:26 -0500
Date: Thu, 7 Mar 2013 10:42:58 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Subject: [GIT PULL] regulator updates for v3.9
Message-ID: <20130307024256.GE22554@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a+b56+3nqLzpiR9O"
Content-Disposition: inline
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a+b56+3nqLzpiR9O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-3.9-rc1

for you to fetch changes up to 8870d4029acda2666700bb5fd94d46b143f92ec4:

  Merge remote-tracking branch 'regulator/fix/twl' into tmp (2013-03-05 10:12:43 +0800)

----------------------------------------------------------------

regulator: Fixes for v3.9

A few small things here and there, nothing major here really.  The
conversion of twl4030ldo_ops to get_voltage_sel is a fix, as covered in
the commit log it fixes inconsistency in handling of the IS_UNSUP()
feature in the driver.

----------------------------------------------------------------
Andrzej Hajda (1):
      regulator: fixed regulator_bulk_enable unwinding code

Axel Lin (1):
      regulator: twl: Convert twl4030ldo_ops to get_voltage_sel

Dmitry Torokhov (1):
      regulator: db8500-prcmu - remove incorrect __exit markup

Graeme Gregory (1):
      regulator: palmas: fix number of SMPS voltages

Mark Brown (5):
      Merge remote-tracking branch 'regulator/fix/core' into tmp
      Merge remote-tracking branch 'regulator/fix/db8500' into tmp
      Merge remote-tracking branch 'regulator/fix/doc' into tmp
      Merge remote-tracking branch 'regulator/fix/palmas' into tmp
      Merge remote-tracking branch 'regulator/fix/twl' into tmp

Nishanth Menon (2):
      regulator: core: update kernel documentation for regulator_desc
      regulator: core: fix documentation error in regulator_allow_bypass

 drivers/regulator/core.c             |   12 ++++++++----
 drivers/regulator/db8500-prcmu.c     |    4 ++--
 drivers/regulator/palmas-regulator.c |    3 ++-
 drivers/regulator/twl-regulator.c    |    9 ++++-----
 include/linux/regulator/driver.h     |    2 ++
 5 files changed, 18 insertions(+), 12 deletions(-)

--a+b56+3nqLzpiR9O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRN/6NAAoJELSic+t+oim9hYIP/RQ6KqOxO4p3NOYDrA3Spw3K
e3g6zAx6yqiRN32qpFhSo6Ac/U7PRJ+5lZmU5I0zl5GDqm0j4noQmJh309u4FdF6
Ir3QcOYFsi5ceVtJUgMo7M8RIRnF0O2FwJzvrGa3sGzYPuY2Oev3lYk4/1bqEgty
nYUFbYeb3ZcwXeWJXBzleMpgN+mcsoIorYuf1wSzry0gUQpyLNZeaHTI8VWqj4NN
NvHr2fRSUgyQhQqFBsOOSbCM4q1+uy6D3wU1Pb3jZsV8hpXmDpcS3s2KKpi2H+0n
/3fzZ+OiSmaxpbGSQIdrT2MwCaR5zTtxrJpDDWmruExAHB2upNNk/rSb9esIW9L8
+mojimWQw7ZEsgK5VrYHLktqtMWqh3nr7k29MXEaa51IHoiIoHyOk7sigDQcsxcH
26/3Yy2A9meqjoXbzKQIIwEdlbITHDRwPzAEUOMk7oU0h3ax23FOpMFT2kJOvy/B
F+AekDojAkJSqNGWoUBpGFC6eC+VdctUdSTFqfTGtlICkzSdLccm6p4XulxEDCwr
NkAnqce2rEqVvrbbZmPrSvnZcTWXD33S4amz7VeouQDhpcQoZZ8ogc6+L9wtf0YS
vu46dZsC5ygAgfTcttpDsWZZNf0yvDqYwcAS8ov9mW3g/jrwMtDqMMVr41otdZZ6
2H8zRFXGyRjSTo6IzPwA
=X4qt
-----END PGP SIGNATURE-----

--a+b56+3nqLzpiR9O--
