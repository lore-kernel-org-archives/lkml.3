Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaLTTm7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 14:42:59 -0500
Received: from sauhun.de ([89.238.76.85]:52163 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbaLTTm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 14:42:56 -0500
Date: Sat, 20 Dec 2014 20:42:52 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.19
Message-ID: <20141220194247.GA1552@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

here is a second pull request for I2C. Included are two bugfixes needing
some bigger refactoring (sh_mobile: deferred probe with DMA, mv64xxx:
fix offload support) and one deprecated driver removal I thought would
go in via ppc but I misunderstood. It has a proper ack from BenH.

Please pull,

   Wolfram


The following changes since commit 603ba7e41bf5d405aba22294af5d075d8898176d:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs (2014-12-16 15:53:03 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-next

for you to fetch changes up to fe07adec730d271c91f4160f96a0f24fe7553c63:

  i2c: sh_mobile: fix uninitialized var when debug is enabled (2014-12-20 09:28:09 +0100)

----------------------------------------------------------------
Geert Uytterhoeven (1):
      i2c: sh_mobile: I2C_SH_MOBILE should depend on HAS_DMA

Thomas Petazzoni (2):
      i2c: mv64xxx: use BIT() macro for register value definitions
      i2c: mv64xxx: rework offload support to fix several problems

Wolfram Sang (4):
      i2c: sh_mobile: refactor DMA setup
      i2c: sh_mobile: rework deferred probing
      macintosh: therm_pm72: delete deprecated driver
      i2c: sh_mobile: fix uninitialized var when debug is enabled

 drivers/i2c/busses/Kconfig         |    1 +
 drivers/i2c/busses/i2c-mv64xxx.c   |  328 +++---
 drivers/i2c/busses/i2c-sh_mobile.c |  112 +-
 drivers/macintosh/Kconfig          |   10 -
 drivers/macintosh/Makefile         |    1 -
 drivers/macintosh/therm_pm72.c     | 2278 ------------------------------------
 drivers/macintosh/therm_pm72.h     |  326 ------
 7 files changed, 252 insertions(+), 2804 deletions(-)
 delete mode 100644 drivers/macintosh/therm_pm72.c
 delete mode 100644 drivers/macintosh/therm_pm72.h

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUldE3AAoJEBQN5MwUoCm2xoUQAKOC4zzHDTBnmZqJWzkO0tS6
Pu79Kj39KuaDKhQeSsZEOv1ZUbUY9R6ABAJIZ0/VdHyG1f5R4h3dnLXxJjMvci91
wrwp1crImPd98/s+jIm36WxTDrry07M0M+GBXQ40YnBtrp0By9w3PDiIgza+Ihon
uQQVt36jantoj7HcReZVS/hOaG5YsNQHbED7I16KS9VZ7cTBH2kv0BwXecuJraYt
vIRfbnS1XK/ha3ZgWUCMtS8SDF7S+XTvPgbT2rbrLsccYFLnT08tuaxLtPL7s4Af
jg94FONdPdFbm6rdNFUyqrsn2XxgALgnZEpCGcdHxBUs7UrFO6YL1qg4Auks2nml
2TiSWN6JJfMHEUuxN8ePd/fbO4y+lGhPwGjQ1FqcKYw9UWRqZvmZO61NR9ZSjh4o
6qeSIi7JaGgue8VD2Dfd36njYb3tpWXIny0c6xN0PJIMX1La38/Wm59mYQURuh7/
Ch/IpMm5nM2OjvOAicvE8R9ASkaK6hHzHCHIC5Bbxv+/0ga7rCU82vFFldfvJC2H
paFi0DTdxpsTMgddAigwr9Ku68IIDNB6GUs/KOnNd2/bV5M/BLmUWArz5y34AZOz
IYA433AxPe/B5Wi2dXQiO+JI9XP/EHCqsVEK1DuFVXYKQEtr4U+UvIGFfvRrjkm5
QXQsDER4BCuYcYph/gQf
=92Cu
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
