Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaDDJKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 05:10:19 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:36217 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbaDDJKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 05:10:13 -0400
Date: Fri, 4 Apr 2014 11:09:28 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] pwm: Changes for v3.15-rc1
Message-ID: <20140404090928.GA29738@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm.git tags/pwm/for-3.15-rc1

for you to fetch changes up to 2ae69a460413615c82381b240df3800a909100d3:

  pwm: pxa: Constify OF match table (2014-04-01 14:06:43 +0200)

Thanks,
Thierry

----------------------------------------------------------------
pwm: Changes for v3.15-rc1

The legacy HAVE_PWM Kconfig symbol is finally being retired. Thanks a
lot to Sascha Hauer for doing that.

Three new drivers are added: Freescale FTM, Cirrus Logic CLPS711X and
Intel Low Power Subsystem.

An assortment of fixes and cleanups rounds things off for this release
cycle.

----------------------------------------------------------------
Alexander Shiyan (1):
      pwm: Add CLPS711X PWM support

Alexandre Belloni (2):
      pwm: atmel: Fix polarity handling
      pwm: atmel: correct CDTY calculation

Jingoo Han (2):
      pwm: samsung: Use SIMPLE_DEV_PM_OPS macro
      pwm: pxa: Use of_match_ptr()

Mika Westerberg (1):
      pwm: add support for Intel Low Power Subsystem PWM

Richard Weinberger (1):
      pwm: renesas-tpu: Add dependency on HAS_IOMEM

Sascha Hauer (1):
      pwm: Remove obsolete HAVE_PWM Kconfig symbol

Thierry Reding (3):
      Revert "pwm: pxa: Use of_match_ptr()"
      pwm: pxa: Fix typo "pwm" -> "PWM"
      pwm: pxa: Constify OF match table

Xiubo Li (2):
      pwm: Add Freescale FTM PWM driver support
      Documentation: Add device tree bindings for Freescale FTM PWM.

 .../bindings/pwm/cirrus,clps711x-pwm.txt           |  16 +
 .../devicetree/bindings/pwm/pwm-fsl-ftm.txt        |  35 ++
 arch/arm/Kconfig                                   |   4 -
 arch/arm/mach-pxa/Kconfig                          |  15 -
 arch/mips/Kconfig                                  |   1 -
 drivers/input/misc/Kconfig                         |   4 +-
 drivers/pwm/Kconfig                                |  30 ++
 drivers/pwm/Makefile                               |   3 +
 drivers/pwm/pwm-atmel.c                            |   9 +-
 drivers/pwm/pwm-clps711x.c                         | 176 ++++++++
 drivers/pwm/pwm-fsl-ftm.c                          | 495 +++++++++++++++++++++
 drivers/pwm/pwm-lpss.c                             | 183 ++++++++
 drivers/pwm/pwm-pxa.c                              |   4 +-
 drivers/pwm/pwm-samsung.c                          |   5 +-
 include/linux/pwm.h                                |   2 +-
 15 files changed, 952 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/cirrus,clps711x-pwm.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
 create mode 100644 drivers/pwm/pwm-clps711x.c
 create mode 100644 drivers/pwm/pwm-fsl-ftm.c
 create mode 100644 drivers/pwm/pwm-lpss.c

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPnbIAAoJEN0jrNd/PrOhi+IP+gKEt85mBnI6IWvQtjUs9eEc
DJmr5Wdtd0NLbU4E86QrRXfL8JDqmlOvybdmJ4510ChrTUCk+qIcK4aDHwmkqH11
x8wDTBslRc66R66Dq+e2JDKWL+WkBxqYUuvkeLwd55h2QZ5XqZIsodEo1sPct3dD
J4K+wAoVl20BkXXf19KlJtiMaKXq5XeC9kb4l1eEqUldixNqQwkPe0TbcLTBz11R
GDUrsSIjCI8EEHU0MijpNFmLBLNbQiiNRrM89OwHxzH/wnfDiyRIJjbOi2PtoMhY
KV9xsewRWQxHjcVGx47PL78RaK+C4qm2CDHSxYqcVjy65M0hlGV+XaxqEkvBLRQ2
WTKgTwAsehJ6HDHzJZg3bkGy2uSN4syCp04+MG1E5v+5wF3x1w6WvK52MsixNXmv
06Z4ajBXR5HJp1iiQnIYuOtWS+nfR2xbrfEpziTqR3iSx5pAxNnWBU5KTk9GpMt4
YSbFzRJDy5IJAaJEiA6HGDS4EVmUXN+N3fd9HgCfCd00sQqnhhg2TMFKzWpAfDRK
p24CDP0twoGfS2BvOxTeSZvovselsSJH7EMGl3jyYr+oVk1N2D67ch5tTXjbQ31P
YmKJtIQl/+an8eH01yV9BiFV+FvfE/icwF+ftVLAo2Qz79csRe/Lr/6NujBgQdyE
EwM0LNMCNtLi0esWjmLO
=Taii
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
