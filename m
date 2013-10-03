Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab3JCXGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 19:06:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34072 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab3JCXGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 19:06:11 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Russell King <linux@arm.linux.org.uk>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 0/4]Re-organize DEBUG_UART for MSM and add support for MSM8974
Date: Thu,  3 Oct 2013 16:05:53 -0700
Message-Id: <1380841557-2673-1-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a pre-cursor, this series cleans-up the DEBUG_UART configs for msm and
includes patches to add basic board support for MSM8974 and debug uart support
for it as well.
The debug uart patches will be added to Russell's patch tracker and hence were
separated from the MSM8974 patch.

Rohit Vaswani (4):
  ARM: debug: Create CONFIG_DEBUG_MSM_UART and re-organize the selects
    for MSM
  ARM: msm: Add support for APQ8074 Dragonboard
  ARM: debug: msm: Add DEBUG_LL support for ARCH_MSM8974
  defconfig: msm_defconfig: Enable CONFIG_ARCH_MSM8974

 arch/arm/Kconfig.debug                         | 24 ++++++++++++++----
 arch/arm/boot/dts/Makefile                     |  3 ++-
 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts |  6 +++++
 arch/arm/boot/dts/qcom-msm8974.dtsi            | 35 ++++++++++++++++++++++++++
 arch/arm/configs/msm_defconfig                 |  1 +
 arch/arm/include/debug/msm.S                   |  5 ++++
 arch/arm/mach-msm/Kconfig                      | 13 ++++++++++
 arch/arm/mach-msm/board-dt.c                   |  9 +++++++
 8 files changed, 90 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
 create mode 100644 arch/arm/boot/dts/qcom-msm8974.dtsi

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

