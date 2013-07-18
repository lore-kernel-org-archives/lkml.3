Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934233Ab3GRUHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:07:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49697 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759102Ab3GRUHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 16:07:32 -0400
From: David Brown <davidb@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Subject: [PATCH 0/3] MSM gpio fixes
Date: Thu, 18 Jul 2013 13:07:12 -0700
Message-Id: <1374178035-19943-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rohit sent these three fixes out on June 18.  I still need a
devicetree ack for the first patch, and would like these to get pulled
in for v3.11

Rohit Vaswani (3):
  ARM: msm: dts: Fix the gpio register address for msm8960
  drivers: gpio: msm: Fix the error condition for reading ngpio
  ARM: msm: Consolidate gpiomux for older architectures

 arch/arm/boot/dts/msm8960-cdp.dts |  4 ++--
 arch/arm/mach-msm/Kconfig         |  3 +--
 arch/arm/mach-msm/gpiomux-v1.c    | 33 ---------------------------------
 arch/arm/mach-msm/gpiomux.h       | 10 ----------
 drivers/gpio/gpio-msm-v2.c        |  2 +-
 5 files changed, 4 insertions(+), 48 deletions(-)
 delete mode 100644 arch/arm/mach-msm/gpiomux-v1.c

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

