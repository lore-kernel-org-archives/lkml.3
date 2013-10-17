Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762857Ab3JQVbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:31:34 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:32776 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762807Ab3JQVbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:31:32 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rohit Vaswani <rvaswani@codeaurora.org>
Subject: [PATCH 0/3] APQ8074 updates
Date: Thu, 17 Oct 2013 14:31:26 -0700
Message-Id: <1382045489-21075-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.1.516.g1d25dd4
In-Reply-To: <1382034310-31147-1-git-send-email-rvaswani@codeaurora.org>
References: <1382034310-31147-1-git-send-email-rvaswani@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset simplifies the ARCH_MSM_DT config and adds some more
nodes for devices that have drivers merged in the upstream kernel.

Stephen Boyd (3):
  ARM: msm: Simplify ARCH_MSM_DT config
  ARM: dts: MSM8974: Add restart node
  ARM: dts: MSM8974: Add MMIO architected timer node

 arch/arm/boot/dts/qcom-msm8974.dtsi | 64 +++++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/Kconfig           |  6 ++--
 2 files changed, 68 insertions(+), 2 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

