Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaH1Pf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:35:26 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:43094 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaH1PfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:35:25 -0400
Date: Thu, 28 Aug 2014 16:35:19 +0100
From: Lee Jones <lee.jones@linaro.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Fixes for MFD due for the v3.17 -rcs
Message-ID: <20140828153519.GV24579@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-fixes-3.17

for you to fetch changes up to daebabd578647440d41fc9b48d8c7a88dc2f7ab5:

  mfd: twl4030-power: Fix PM idle pin configuration to not conflict with regulators (2014-08-28 15:57:55 +0100)

----------------------------------------------------------------
Couple of simple fixes due for the 3.17 rcs

(and a sneaky document addition that slipped from the previous pull-request)
----------------------------------------------------------------
Fabio Estevam (1):
      mfd: ab8500-core: Use 'ifdef' for config options

Hans Wennborg (2):
      mfd: omap-usb-host: Fix %d confusingly prefixed with 0x in format string
      mfd: htc-i2cpld: Fix %d confusingly prefixed with 0x in format string

Linus Walleij (1):
      mfd: tc3589x: Add device tree bindings

Tony Lindgren (1):
      mfd: twl4030-power: Fix PM idle pin configuration to not conflict with regulators

 Documentation/devicetree/bindings/mfd/tc3589x.txt | 107 ++++++++++++++++++++++
 arch/arm/boot/dts/omap3-n900.dts                  |   2 +-
 drivers/mfd/ab8500-core.c                         |   2 +-
 drivers/mfd/htc-i2cpld.c                          |   2 +-
 drivers/mfd/omap-usb-host.c                       |   2 +-
 drivers/mfd/twl4030-power.c                       |  20 ++--
 6 files changed, 121 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/tc3589x.txt

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
