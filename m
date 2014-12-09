Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaLIKOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:14:45 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:54861 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbaLIKOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:14:43 -0500
Date: Tue, 9 Dec 2014 10:14:38 +0000
From: Lee Jones <lee.jones@linaro.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Backlight for v3.19
Message-ID: <20141209101438.GX3951@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/backlight.git tags/backlight-for-linus-3.19

for you to fetch changes up to 3d6969a641d01cc9b6aa199a6f01eb1802522baf:

  MAINTAINERS: Remove my name from Backlight subsystem (2014-12-09 09:24:47 +0000)

----------------------------------------------------------------
 - Clean-up leaky resources; pwm_bl
 - Simplify Device Tree initialisation; lp855x_bl
 - Add Regulator support; lp855x
 - Remove Bryan from the Maintainer list -- new baby, no time :)

----------------------------------------------------------------
Bryan Wu (1):
      MAINTAINERS: Remove my name from Backlight subsystem

Sean Paul (2):
      backlight: lp855x: Refactor DT parsing code
      backlight: lp855x: Add supply regulator to lp855x

Vladimir Zapolskiy (1):
      backlight: pwm: Clean-up pwm requested using legacy API

 .../devicetree/bindings/video/backlight/lp855x.txt |  2 +
 MAINTAINERS                                        |  1 -
 drivers/video/backlight/lp855x_bl.c                | 55 ++++++++++++++--------
 drivers/video/backlight/pwm_bl.c                   |  5 +-
 include/linux/platform_data/lp855x.h               |  2 +
 5 files changed, 44 insertions(+), 21 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
