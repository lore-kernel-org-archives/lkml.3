Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbaFLIRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:17:37 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:33486 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbaFLIRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:17:34 -0400
Date: Thu, 12 Jun 2014 09:17:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: [GIT PULL] MFD changes due for v3.16 (mk2)
Message-ID: <20140612081729.GC11421@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I missed collecting these patches due to a branch/tag naming
ambiguity.  Completely my own fault, as I mindlessly named a branch
and tag identically.  Sorry for the fuss.

The following changes since commit 455c6fdbd219161bd09b1165f11699d6d73de11c:

  Linux 3.14 (2014-03-30 20:40:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-for-linus-3.16-1

for you to fetch changes up to 43fef47f94a1ae46fb2720dada32fa3b5547bee2:

  mfd: twl4030-power: Add a configuration to turn off oscillator during off-idle (2014-05-28 08:06:18 +0100)

----------------------------------------------------------------
This pull-request contains some misplaced patches from Tony
Lindgren that should have been part of the initial one.

----------------------------------------------------------------
Tony Lindgren (7):
      mfd: twl-core: Fix idle mode signaling for omaps when booted with device tree
      mfd: twl4030-power: Fix hang on reboot if sleep configuration was loaded earlier
      mfd: twl4030-power: Fix some defines for SW_EVENTS
      mfd: twl4030-power: Add generic reset configuration
      mfd: twl4030-power: Add recommended idle configuration
      mfd: twl4030-power: Add support for board specific configuration
      mfd: twl4030-power: Add a configuration to turn off oscillator during off-idle

 .../devicetree/bindings/mfd/twl4030-power.txt      |  17 +-
 arch/arm/mach-omap2/omap_twl.c                     |  60 -----
 drivers/mfd/twl-core.c                             |  15 ++
 drivers/mfd/twl4030-power.c                        | 286 +++++++++++++++++++--
 include/linux/i2c/twl.h                            |   4 +
 5 files changed, 296 insertions(+), 86 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
