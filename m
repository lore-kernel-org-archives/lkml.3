Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaF0KjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 06:39:21 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:58287 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaF0KjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 06:39:20 -0400
Date: Fri, 27 Jun 2014 11:39:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] MFD fixes for v3.16 -rcs
Message-ID: <20140627103915.GK19645@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-fixes-3.16

for you to fetch changes up to 7602e05df73f3c775d5ef808c0bc4af9711e4438:

  mfd: ab8500: Fix dt irq mapping (2014-06-26 13:34:15 +0100)

----------------------------------------------------------------
Couple of simple fixes due for the v3.16 -rcs.

----------------------------------------------------------------
Arnd Bergmann (3):
      mfd: UCB1x00: Enable modular build
      mfd: STw481x: Allow modular build
      mfd: davinci: Voicecodec needs regmap_mmio

Grygorii Strashko (1):
      mfd: ab8500: Fix dt irq mapping

 drivers/mfd/Kconfig       | 5 +++--
 drivers/mfd/ab8500-core.c | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
