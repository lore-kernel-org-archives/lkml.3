Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaJTHyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 03:54:33 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37498 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaJTHy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 03:54:29 -0400
Date: Mon, 20 Oct 2014 09:54:25 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] pwm: Changes for v3.18-rc1
Message-ID: <20141020075424.GA18728@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

I was one of the people taking your statements at face value, so here's
my belated pull request for the PWM tree which I had planned to send in
today anyway. There isn't anything major in this, mostly bug fixes and
cleanup.

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm.git tags/pwm/for-3.18-rc1

for you to fetch changes up to dec02f98ae2e341a2e0bb25f27e84867e5f9f64a:

  pwm: Let PWM_CLPS711X depend on HAS_IOMEM (2014-10-20 09:39:44 +0200)

Thanks,
Thierry

----------------------------------------------------------------
pwm: Changes for v3.18-rc1

There are no new drivers here, only a couple of fixes all over the place.

----------------------------------------------------------------
Alan Cox (1):
      pwm: lpss: Add ACPI and PCI IDs for Intel Braswell

Andy Shevchenko (3):
      pwm: lpss: Properly split driver to parts
      pwm: lpss: pci: Move to use pcim_enable_device()
      pwm: lpss: make it buildable only on X86

Chen Gang (1):
      pwm: Let PWM_CLPS711X depend on HAS_IOMEM

Doug Anderson (1):
      pwm: rockchip: Allow polarity invert on rk3288

Fabio Estevam (1):
      pwm: fsl-ftm: Select REGMAP_MMIO

Geert Uytterhoeven (2):
      pwm: Fix period and polarity in pwm_get() for non-perfect matches
      pwm: Fix uninitialized warnings in pwm_get()

Julia Lawall (1):
      pwm: lpss: use c99 initializers in structures

Liu Ying (3):
      pwm: imx: Fix the macro MX3_PWMCR_PRESCALER(x) definition
      pwm: imx: Cleanup indentation for register definitions
      pwm: imx: Avoid sample FIFO overflow for i.MX PWM version2

Nikolaus Voss (1):
      pwm: atmel: Fix calculation of prescale value

Thierry Reding (1):
      pwm: lpss: Fix build failure on PowerPC

Xiubo Li (4):
      pwm: fsl-ftm: Clean up the code
      pwm: fsl-ftm: Convert to direct regmap API usage
      pwm: fsl-ftm: Document 'big-endian' property
      pwm: Fix possible ZERO_SIZE_PTR pointer dereferencing error.

 .../devicetree/bindings/pwm/pwm-fsl-ftm.txt        |  19 ++-
 .../devicetree/bindings/pwm/pwm-rockchip.txt       |   4 +-
 drivers/pwm/Kconfig                                |  22 +++-
 drivers/pwm/Makefile                               |   2 +
 drivers/pwm/core.c                                 |  27 ++--
 drivers/pwm/pwm-atmel.c                            |  24 ++--
 drivers/pwm/pwm-fsl-ftm.c                          |  90 +++++++-------
 drivers/pwm/pwm-imx.c                              |  71 ++++++++---
 drivers/pwm/pwm-lpss-pci.c                         |  64 ++++++++++
 drivers/pwm/pwm-lpss-platform.c                    |  68 ++++++++++
 drivers/pwm/pwm-lpss.c                             | 137 +++------------------
 drivers/pwm/pwm-lpss.h                             |  32 +++++
 drivers/pwm/pwm-rockchip.c                         |  57 +++++++--
 13 files changed, 399 insertions(+), 218 deletions(-)
 create mode 100644 drivers/pwm/pwm-lpss-pci.c
 create mode 100644 drivers/pwm/pwm-lpss-platform.c
 create mode 100644 drivers/pwm/pwm-lpss.h

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJURL+wAAoJEN0jrNd/PrOh464QAMHgZxQd8XJyIYVI899E+Di2
I342wkJ7Ikp7BQZsFrfeF5CG69MXjPWk+UrgkEucBHQc2cYpZaU/3HssXaZ3ifhK
2iyInGovnzvo0xqlam8sUQp50nxQMYUKOiJt9WspClhDFAjkYxChSRoptQUCrZL0
cCwQxn1wKfrmUAfcnWxnKXi2252eHR+3ZYPIWkyR2cNJcjODZj4n1vavmXDyFn5a
5JLqSNA0O58CQipJKO1dijuBsREWTljFUf9mjh4y7lLC52iOvlu5LQV+4nJJnbm+
DRvFVAwQU1noV25wu5ymuQcpqPEWg9oKQhajh5ywyzpMLcYNusLh2u/vMwHufuJe
l3i2qotY4+i/LN+ylaJO2C6R8Kd4b/DJIT3jPipORyGDpiX+airTjVcUimT8SZeJ
O5tZfXiMQJko4NT4+isy7xf/T5GAoTaqzfpRfHKcUnL+cvzp0xen4gZkyEdQ3AnI
g/SMGIZaBeY25w/a++c7u/CgJEk95YqX901EBXEp574KuQy4fO0R2d8DIksa3yzH
/8CxE2wsVYMXh87kD1+z8X7icLuZZTH2uyT3KqIsT5UbO6bD44YQ8jPLh8i8BPaJ
0oJfpJL4QJ0QbbYIkWOtKWhuoez+CA8Z09TvKiGbbzyAcEJvu0Tt+LtmmpNvTesa
7zrHIyenwBLOK0mOO+c0
=41u8
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
