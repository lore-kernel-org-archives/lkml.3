Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbaHHLWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 07:22:30 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46368 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbaHHLW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 07:22:27 -0400
Date: Fri, 8 Aug 2014 13:22:22 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] pwm: Changes for v3.17-rc1
Message-ID: <20140808112220.GA21202@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm.git tags/pwm/for-3.17-rc1

for you to fetch changes up to f6306299080bbb1a77ad39494203f5397a5c2630:

  pwm: rockchip: Added to support for RK3288 SoC (2014-08-08 13:12:47 +0200)

Thanks,
Thierry

----------------------------------------------------------------
pwm: Changes for v3.17-rc1

The set of changes for this merge window contains two new drivers: one
for Rockchip SoCs and another for STMicroelectronics STiH4xx SoCs. The
remainder of the changes are the usual small cleanups such as removing
redundant OOM messages, signalling that a PWM chip's operations can
sleep and removing an unneeded dependency.

----------------------------------------------------------------
Ajit Pal Singh (4):
      pwm: sti: Fix PWM prescaler handling
      pwm: sti: Ensure same period values for all channels
      pwm: sti: Sync between enable/disable calls
      pwm: sti: Remove PWM period table

Beniamino Galvani (2):
      pwm: add Rockchip SoC PWM support
      pwm: rockchip: document device tree bindings

Caesar Wang (2):
      pwm: rockchip: document RK3288 SoC compatible
      pwm: rockchip: Added to support for RK3288 SoC

Heikki Krogerus (1):
      pwm: lpss: remove dependency on clk framework

Jingoo Han (1):
      pwm: pwm-tipwmss: remove unnecessary OOM messages

Lee Jones (2):
      pwm: sti: Add new driver for ST's PWM IP
      pwm: sti: Supply Device Tree binding documentation for ST's PWM IP

Shawn Guo (1):
      pwm: imx: set can_sleep flag for imx_pwm

 .../devicetree/bindings/pwm/pwm-rockchip.txt       |  20 +
 Documentation/devicetree/bindings/pwm/pwm-st.txt   |  41 ++
 drivers/pwm/Kconfig                                |  17 +
 drivers/pwm/Makefile                               |   2 +
 drivers/pwm/pwm-imx.c                              |   1 +
 drivers/pwm/pwm-lpss.c                             |  32 +-
 drivers/pwm/pwm-rockchip.c                         | 264 +++++++++++++
 drivers/pwm/pwm-sti.c                              | 418 +++++++++++++++++++++
 drivers/pwm/pwm-tipwmss.c                          |   4 +-
 9 files changed, 774 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-st.txt
 create mode 100644 drivers/pwm/pwm-rockchip.c
 create mode 100644 drivers/pwm/pwm-sti.c

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT5LLsAAoJEN0jrNd/PrOhnmkP/0TGReO7l2oV8SIoIr0k8v6e
iw1gYEjRyuP0nZJxCQ6HjDl846xWGMp9IR/6DGUjeOysGkZABpvC1Z0J1xVVr8/m
c9jSv8AwQoRmLzkiGGYotze25R0PPo/byl/C2kV32YNEIlV2qxxBZYs3gXrMFs/Q
RvI1o0eGp0sagWpvMnW6udwVu3aSuvK9Zf3iDffUk4Sz6i8Tb5wPid7DDPdtxy4a
xZVASK0/DGizLklmQeOhldkr5ToxW7Hh83Gg7iMkrZOC8r8DNW2vR4V6gCy31XVQ
dOOMtwca1p0w9VOhhhSrqlo7NEXAyUDD61RC2tB+EkqZNuMo7/2kotAYlw/E6Qei
pA6bfmuGipiEEN8m+T6IPVfEobQUAl9UwJorLBeUCy8nVmYFCNzJTlla/JikSYYW
4U28ldsphbv75B6gjhzI2s5XfXjD7nRhq8Lq5XRmMM4cGJSkHq9NADsmId6noQaJ
gBJyn4QMRn9PyE61W/p/skLpX573Ky9VY51E1Lwe6lawotqFn8dSbKll5Cmr3fXR
X7UEHumbtIQGQtL0qkcK8j3aX+xsiH6LsVIaSowBHUEQ/yY8wxdnRDyL5K6Vgh+I
OucdsPPq78Td/FCdYxGmTRuCSCJkJaj4VWl+c86RCap9YVtgqAa+RCemBdKxuMTA
J/M+PgV0lBcNXZmDPRZS
=FUAn
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
