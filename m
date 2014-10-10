Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaJJJiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:38:50 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:35443 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaJJJir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:38:47 -0400
Date: Fri, 10 Oct 2014 10:38:42 +0100
From: Lee Jones <lee.jones@linaro.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Backlight for v3.18
Message-ID: <20141010093841.GG26795@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/backlight.git tags/backlight-for-linus-3.18

for you to fetch changes up to b6af73b42219aa6b253ef5c0020eff1019485ffc:

  backlight: omap1: add blank line after declarations (2014-08-29 08:27:53 +0100)

----------------------------------------------------------------
Changes to existing drivers
  - Checkpatch fixes
  - Removal of unused code in generic_bl
  - Removal of superfluous .owner attribute

New drivers/supported devices
  - None

(Re-)moved drivers
  - None

----------------------------------------------------------------
Fabio Estevam (1):
      backlight: generic_bl: Remove unused function

Jingoo Han (18):
      backlight: adp5520: Add blank line after declarations
      backlight: adp8860: Add blank line after declarations
      backlight: adp8870: Add blank line after declarations
      backlight: ams369fg06: Remove 'else' after a return
      backlight: corgi_lcd: Add blank line after declarations
      backlight: cr_bllcd: Add blank line after declarations
      backlight: ili922x: Remove 'else' after a return
      backlight: ld9040: Remove 'else' after a return
      backlight: lm3639: Remove unnecessary return statements
      backlight: lms501kf03: Remove 'else' after a return
      backlight: lp855x: Add blank line after declarations
      backlight: pcf50633: Add blank line after declarations
      backlight: s6e63m0: Remove 'else' after a return
      backlight: tdo24m: Add blank line after declarations
      backlight: wm831x_bl: Add blank line after declarations
      backlight: jornada720: Remove 'else' after a return
      backlight: jornada720: Remove 'else' after a return
      backlight: omap1: add blank line after declarations

Peter Griffin (1):
      backlight: Remove .owner field for drivers using module_platform_driver

 drivers/video/backlight/88pm860x_bl.c        |  1 -
 drivers/video/backlight/aat2870_bl.c         |  1 -
 drivers/video/backlight/adp5520_bl.c         |  2 +-
 drivers/video/backlight/adp8860_bl.c         |  3 +++
 drivers/video/backlight/adp8870_bl.c         |  4 ++++
 drivers/video/backlight/ams369fg06.c         |  6 +++---
 drivers/video/backlight/as3711_bl.c          |  1 -
 drivers/video/backlight/corgi_lcd.c          |  1 +
 drivers/video/backlight/cr_bllcd.c           |  1 +
 drivers/video/backlight/da903x_bl.c          |  1 -
 drivers/video/backlight/da9052_bl.c          |  1 -
 drivers/video/backlight/ep93xx_bl.c          |  1 -
 drivers/video/backlight/generic_bl.c         | 18 ------------------
 drivers/video/backlight/gpio_backlight.c     |  1 -
 drivers/video/backlight/ili922x.c            | 11 ++++++-----
 drivers/video/backlight/jornada720_bl.c      |  6 +++---
 drivers/video/backlight/jornada720_lcd.c     |  6 +-----
 drivers/video/backlight/ld9040.c             |  6 +++---
 drivers/video/backlight/lm3533_bl.c          |  1 -
 drivers/video/backlight/lm3639_bl.c          |  2 --
 drivers/video/backlight/lms501kf03.c         | 12 ++++++------
 drivers/video/backlight/lp855x_bl.c          |  2 ++
 drivers/video/backlight/lp8788_bl.c          |  1 -
 drivers/video/backlight/max8925_bl.c         |  1 -
 drivers/video/backlight/omap1_bl.c           |  1 +
 drivers/video/backlight/ot200_bl.c           |  1 -
 drivers/video/backlight/pandora_bl.c         |  1 -
 drivers/video/backlight/pcf50633-backlight.c |  1 +
 drivers/video/backlight/platform_lcd.c       |  1 -
 drivers/video/backlight/pwm_bl.c             |  1 -
 drivers/video/backlight/s6e63m0.c            | 12 ++++++------
 drivers/video/backlight/tdo24m.c             |  2 ++
 drivers/video/backlight/tps65217_bl.c        |  1 -
 drivers/video/backlight/wm831x_bl.c          |  2 +-
 34 files changed, 45 insertions(+), 68 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
