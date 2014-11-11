Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbaKKKqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:46:49 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:44288 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaKKKqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:46:48 -0500
Date: Tue, 11 Nov 2014 10:46:42 +0000
From: Lee Jones <lee.jones@linaro.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] MFD fixes for v3.18
Message-ID: <20141111104642.GV24004@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-fixes-3.18

for you to fetch changes up to 481c7f868c6d855f31a29c69b445ac4aee9625a6:

  mfd: twl4030-power: Fix poweroff with PM configuration enabled (2014-11-10 15:22:04 +0000)

----------------------------------------------------------------
 - Register offset fix for stmpe
 - Eradicate build warning when !PM in rtsx_pcr
 - Fix device ID collision when multiple boards are connected in viperboard
 - Use correct Regmap handle - fixing unhanded IRQs in max77693
 - Unmask MUIC IRQs in max77693
 - Clear VBUS & CHG bits so board doesn't reboot instead of poweroff in twl4030

----------------------------------------------------------------
Johan Hovold (1):
      mfd: viperboard: Fix platform-device id collision

Krzysztof Kozlowski (2):
      mfd: max77693: Use proper regmap for handling MUIC interrupts
      mfd: max77693: Fix always masked MUIC interrupts

Linus Walleij (1):
      mfd: stmpe: Fix STMPE24xx GPMR LSB

Thierry Reding (1):
      mfd: rtsx: Fix build warnings for !PM

Tony Lindgren (1):
      mfd: twl4030-power: Fix poweroff with PM configuration enabled

 drivers/mfd/max77693.c               | 14 +++++++++-
 drivers/mfd/rtsx_pcr.c               |  2 ++
 drivers/mfd/stmpe.h                  |  2 +-
 drivers/mfd/twl4030-power.c          | 52 ++++++++++++++++++++++++++++++++++++
 drivers/mfd/viperboard.c             |  5 ++--
 include/linux/mfd/max77693-private.h |  7 +++++
 6 files changed, 78 insertions(+), 4 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
