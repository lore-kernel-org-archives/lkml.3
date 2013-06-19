Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934344Ab3FSByO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:54:14 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39981 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934106Ab3FSBxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:53:38 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 0/3] ARM: MSM: Consolidate MSM gpiomux for 7X30 and 8X50
Date: Tue, 18 Jun 2013 18:53:30 -0700
Message-Id: <1371606813-5575-1-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is based on David Brown's for-next branch
git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git for-next

The previous gpio patches left some room for consolidation and required
a few fixes. This patch provides the necessary patches to do that.

Rohit Vaswani (3):
  ARM: msm: dts: Fix the gpio register address for msm8960
  drivers: gpio: msm: Fix the error condition for reading ngpio
  ARM: msm: Consolidate gpiomux for older architectures

 arch/arm/boot/dts/msm8960-cdp.dts |    4 ++--
 arch/arm/mach-msm/Kconfig         |    3 +--
 arch/arm/mach-msm/gpiomux-v1.c    |   33 ---------------------------------
 arch/arm/mach-msm/gpiomux.h       |   10 ----------
 drivers/gpio/gpio-msm-v2.c        |    2 +-
 5 files changed, 4 insertions(+), 48 deletions(-)
 delete mode 100644 arch/arm/mach-msm/gpiomux-v1.c

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

