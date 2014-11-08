Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbaKHRPP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 12:15:15 -0500
Received: from sauhun.de ([89.238.76.85]:36635 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbaKHRPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 12:15:13 -0500
Date: Sat, 8 Nov 2014 18:16:16 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.18
Message-ID: <20141108171611.GA6592@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

here is one bigger cleanup (FSF address removal) and two bugfixes for
I2C. Please pull.

Thanks,

   Wolfram


The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-current

for you to fetch changes up to e4df3a0b62285130ac0a35cf07678c154ffb649d:

  i2c: core: Dispose OF IRQ mapping at client removal time (2014-11-07 19:03:18 +0100)

----------------------------------------------------------------
Laurent Pinchart (1):
      i2c: core: Dispose OF IRQ mapping at client removal time

Wolfram Sang (2):
      i2c: remove FSF address
      i2c: at91: don't account as iowait

 drivers/i2c/algos/i2c-algo-bit.c            |  5 -----
 drivers/i2c/algos/i2c-algo-pca.c            |  5 -----
 drivers/i2c/algos/i2c-algo-pcf.c            |  5 -----
 drivers/i2c/algos/i2c-algo-pcf.h            |  7 +------
 drivers/i2c/busses/i2c-ali1535.c            |  4 ----
 drivers/i2c/busses/i2c-ali15x3.c            |  4 ----
 drivers/i2c/busses/i2c-amd756-s4882.c       |  4 ----
 drivers/i2c/busses/i2c-amd756.c             |  4 ----
 drivers/i2c/busses/i2c-at91.c               |  2 +-
 drivers/i2c/busses/i2c-au1550.c             |  4 ----
 drivers/i2c/busses/i2c-cpm.c                |  4 ----
 drivers/i2c/busses/i2c-davinci.c            |  4 ----
 drivers/i2c/busses/i2c-designware-core.c    |  4 ----
 drivers/i2c/busses/i2c-designware-core.h    |  4 ----
 drivers/i2c/busses/i2c-designware-pcidrv.c  |  4 ----
 drivers/i2c/busses/i2c-designware-platdrv.c |  4 ----
 drivers/i2c/busses/i2c-eg20t.c              |  4 ----
 drivers/i2c/busses/i2c-elektor.c            |  6 +-----
 drivers/i2c/busses/i2c-hydra.c              |  4 ----
 drivers/i2c/busses/i2c-i801.c               |  4 ----
 drivers/i2c/busses/i2c-imx.c                |  5 -----
 drivers/i2c/busses/i2c-iop3xx.h             |  6 +-----
 drivers/i2c/busses/i2c-isch.c               |  4 ----
 drivers/i2c/busses/i2c-ismt.c               |  4 ----
 drivers/i2c/busses/i2c-nforce2-s4985.c      |  4 ----
 drivers/i2c/busses/i2c-nforce2.c            |  4 ----
 drivers/i2c/busses/i2c-omap.c               |  4 ----
 drivers/i2c/busses/i2c-parport-light.c      |  4 ----
 drivers/i2c/busses/i2c-parport.c            |  4 ----
 drivers/i2c/busses/i2c-parport.h            |  4 ----
 drivers/i2c/busses/i2c-pasemi.c             |  4 ----
 drivers/i2c/busses/i2c-pca-isa.c            |  4 ----
 drivers/i2c/busses/i2c-piix4.c              |  4 ----
 drivers/i2c/busses/i2c-pmcmsp.c             |  4 ----
 drivers/i2c/busses/i2c-powermac.c           |  4 ----
 drivers/i2c/busses/i2c-s3c2410.c            |  4 ----
 drivers/i2c/busses/i2c-sh_mobile.c          |  4 ----
 drivers/i2c/busses/i2c-sibyte.c             |  4 ----
 drivers/i2c/busses/i2c-simtec.c             |  4 ----
 drivers/i2c/busses/i2c-sis5595.c            |  4 ----
 drivers/i2c/busses/i2c-sis630.c             |  4 ----
 drivers/i2c/busses/i2c-sis96x.c             |  4 ----
 drivers/i2c/busses/i2c-taos-evm.c           |  4 ----
 drivers/i2c/busses/i2c-via.c                |  4 ----
 drivers/i2c/busses/i2c-viapro.c             |  4 ----
 drivers/i2c/busses/i2c-xiic.c               |  4 ----
 drivers/i2c/busses/scx200_acb.c             |  4 ----
 drivers/i2c/i2c-boardinfo.c                 |  5 -----
 drivers/i2c/i2c-core.c                      | 10 ++++------
 drivers/i2c/i2c-core.h                      |  5 -----
 drivers/i2c/i2c-dev.c                       |  5 -----
 drivers/i2c/i2c-smbus.c                     |  5 -----
 drivers/i2c/i2c-stub.c                      |  4 ----
 53 files changed, 8 insertions(+), 223 deletions(-)

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUXk/bAAoJEBQN5MwUoCm20pcQALIWsxpMAu7/XZ5ZqiBmZ0QD
fj8AtTN6JkwTYYy8vjx6HGlhHJrMZNwWixClOtpBpMvvc4ULREdXYFDV4HrSLtQ9
n2Be4gv9XdghQhoZnpbds4QKfoy8jQYrZGdNyQ7I2ht0pmTvXNgfxEB/CsmY157L
vHCvMclnt7osVHn7puhdl9zmYYwzpKZxLaO7KGxt1t3SECmC43RleSBRDTyqTh6Y
jrZ9IYUyYV90T0Ja9661D8UVn72GE7cfAucDwq2DenZzXNBDvEpWMQRR2QujVpkx
yOXjvPK8C5bfolRRcfEwRHHjsmydH/ygvbouAmzwRNRtYCy7TGeQjtZU/ua7LMa9
FGEfLbkLQ+tPlw7XcpIhxcKW2d5f6Wm2YVP1O3NB/MFFlQxcJ+NDiqBzYN4NBVo3
eQOhQE3kcDuRT/7SoO/AAfspg/joUewHW5+5AQkmUEMnkTJedlla5PWb1ZayTFD2
kkK9lVbzP94aACiXMUojZrKeKOYuvGg4CqqShL/bHYKQuuEcPoF8ORPrwuky1qqq
t/6CiB5MbiBDMq+2RCBtT8W/ChZ/EyRT+eS41uADDUl0Dj27+jRriOec7wzyMpk5
e9s8POxrror8Sc8ammMMYwzwA5oLyaW2aTgqINaGDG2lj68819DIY32fR/xGetVE
GFPRi087r6y72CUDOB+i
=hVQV
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
