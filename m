Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbaFLI30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:29:26 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:61400 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbaFLI3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:29:24 -0400
Date: Thu, 12 Jun 2014 09:29:10 +0100
From: Lee Jones <lee.jones@linaro.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Backlight changes due for v3.16
Message-ID: <20140612082910.GA14323@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit d1db0eea852497762cab43b905b879dfcd3b8987:

  Linux 3.15-rc3 (2014-04-27 19:29:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/backlight.git tags/backlight-for-linus-3.16

for you to fetch changes up to ab1e59b4dc0370734ab3afb8de0c10a6f5a211ad:

  backlight: gpio-backlight: Fix warning when the GPIO is on a I2C chip (2014-06-05 10:00:53 +0100)

----------------------------------------------------------------
This pull-request merely contains some very basic build/run-time bug fixes.

----------------------------------------------------------------
Arnd Bergmann (2):
      video/pxa: LCD_CORGI needs BACKLIGHT_CLASS_DEVICE
      video/backlight: LP855X needs PWM

Masanari Iida (1):
      video/backlight: s6e63m0: Fix string type mismatch

Peter Griffin (2):
      video/backlight: LM3630A needs PWM
      video/backlight: LP8788 needs PWM

Tony Lindgren (1):
      backlight: gpio-backlight: Fix warning when the GPIO is on a I2C chip

 drivers/video/backlight/Kconfig          | 8 ++++----
 drivers/video/backlight/gpio_backlight.c | 3 ++-
 drivers/video/backlight/s6e63m0.c        | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
