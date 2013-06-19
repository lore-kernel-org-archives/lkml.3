Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974Ab3FSBDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:03:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38241 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933857Ab3FSBCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:02:33 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 0/4] ARM: MSM: Consolidate GPIOMUX for 7x30 and 8x50
Date: Tue, 18 Jun 2013 18:02:23 -0700
Message-Id: <1371603747-27436-1-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous gpio clean up series left some room for consolidation
and required a few fixes.

Rohit Vaswani (4):
  ARM: msm: dts: Fix the gpio register address for msm8960
  drivers: gpio: msm: Fix the error condition for reading ngpio
  ARM: msm: Consolidate gpiomux for older architectures
  drivers: gpio: msm: Remove __devinit

 arch/arm/boot/dts/msm8960-cdp.dts |    4 ++--
 arch/arm/mach-msm/Kconfig         |    3 +--
 arch/arm/mach-msm/gpiomux-v1.c    |   33 ---------------------------------
 arch/arm/mach-msm/gpiomux.h       |   10 ----------
 drivers/gpio/gpio-msm-v1.c        |    2 +-
 drivers/gpio/gpio-msm-v2.c        |    2 +-
 6 files changed, 5 insertions(+), 49 deletions(-)
 delete mode 100644 arch/arm/mach-msm/gpiomux-v1.c

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

