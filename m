Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbaBSOLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:11:52 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:32873 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbaBSOLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:11:50 -0500
Date: Wed, 19 Feb 2014 14:11:44 +0000
From: Lee Jones <lee.jones@linaro.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: [GIT PULL] MFD fixes for v3.14
Message-ID: <20140219141144.GF10504@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.linaro.org/people/lee.jones/mfd.git tags/mfd-fixes-3.14-1

for you to fetch changes up to 8321bbf8906990e60cdb46be4c909a7780275942:

  mfd: sec-core: sec_pmic_{suspend,resume}() should depend on CONFIG_PM_SLEEP (2014-02-19 13:30:34 +0000)

----------------------------------------------------------------
MFD fixes due for the v3.14 -rcs

Couple of small issues solved:
  - Suspend/Resume call-backs require CONFIG_PM_SLEEP
  - Some drivers written for 32bit architectures fail when compiled
    with a 64bit compiler. The fixes will future proof the drivers.

----------------------------------------------------------------
Geert Uytterhoeven (2):
      mfd: max14577: max14577_{suspend,resume}() should depend on CONFIG_PM_SLEEP
      mfd: sec-core: sec_pmic_{suspend,resume}() should depend on CONFIG_PM_SLEEP

Lee Jones (4):
      mfd: max8997: Naturalise cross-architecture discrepancies
      mfd: max8998: Naturalise cross-architecture discrepancies
      mfd: wm8994-core: Naturalise cross-architecture discrepancies
      mfd: tps65217: Naturalise cross-architecture discrepancies

 drivers/mfd/max14577.c              | 2 ++
 drivers/mfd/max8997.c               | 6 +++---
 drivers/mfd/max8998.c               | 6 +++---
 drivers/mfd/sec-core.c              | 2 ++
 drivers/mfd/tps65217.c              | 4 ++--
 drivers/mfd/wm8994-core.c           | 2 +-
 include/linux/mfd/max8997-private.h | 2 +-
 include/linux/mfd/max8998-private.h | 2 +-
 include/linux/mfd/tps65217.h        | 4 ++--
 9 files changed, 17 insertions(+), 13 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
