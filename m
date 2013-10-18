Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab3JRR4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:56:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54316 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab3JRR4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:56:50 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rohit Vaswani <rvaswani@codeaurora.org>
Subject: [PATCH v2 0/4] APQ8074 updates
Date: Fri, 18 Oct 2013 10:56:42 -0700
Message-Id: <1382119006-22231-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.1.544.g2141c47
In-Reply-To: <1382034310-31147-1-git-send-email-rvaswani@codeaurora.org>
References: <1382034310-31147-1-git-send-email-rvaswani@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset simplifies the ARCH_MSM_DT config and adds some more
nodes for devices that have drivers merged in the upstream kernel.

Changes since v1:
 * Moved nodes into soc node
 * Enabled restart driver in defconfig

Stephen Boyd (4):
  ARM: msm: Simplify ARCH_MSM_DT config
  ARM: dts: MSM8974: Add restart node
  ARM: dts: MSM8974: Add MMIO architected timer node
  ARM: msm_defconfig: Enable restart driver

 arch/arm/boot/dts/qcom-msm8974.dtsi | 64 +++++++++++++++++++++++++++++++++++++
 arch/arm/configs/msm_defconfig      |  2 ++
 arch/arm/mach-msm/Kconfig           |  6 ++--
 3 files changed, 70 insertions(+), 2 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

