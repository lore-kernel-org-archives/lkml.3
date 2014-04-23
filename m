Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbaDWNVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:21:15 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:59896 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbaDWNUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:20:08 -0400
Date: Wed, 23 Apr 2014 14:20:02 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] extcon: Immutable branch between MFD and Extcon
Message-ID: <20140423132002.GI640@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:

  Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/ib-mfd-extcon-3.16

for you to fetch changes up to 8a82b408acad29161c43072727151d373e68116a:

  regulator: max14577: Add support for MAX77836 regulators (2014-04-23 14:09:45 +0100)

----------------------------------------------------------------
Immutable branch between MFD and Extcon due for v3.16 merge-window.

----------------------------------------------------------------
Chanwoo Choi (1):
      extcon: max14577: Change extcon name instead of static name according to device type

Krzysztof Kozlowski (8):
      mfd: max14577: Add muic prefix to regmap config
      mfd: max14577: Add detection of device type
      extcon: max14577: Add max14577 prefix to muic_irqs
      extcon: max14577: Choose muic_irqs according to device type
      mfd: max14577: Add MAX14577 prefix to IRQ defines
      mfd: max77836: Add MAX77836 support to max14577 driver
      extcon: max14577: Add support for MAX77836
      regulator: max14577: Add support for MAX77836 regulators

 drivers/extcon/Kconfig               |   4 +-
 drivers/extcon/extcon-max14577.c     | 174 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------
 drivers/mfd/Kconfig                  |   6 +--
 drivers/mfd/max14577.c               | 315 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------
 drivers/regulator/Kconfig            |   7 ++--
 drivers/regulator/max14577.c         | 277 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------
 include/linux/mfd/max14577-private.h | 222 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------
 include/linux/mfd/max14577.h         |  19 +++++++--
 8 files changed, 836 insertions(+), 188 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
