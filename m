Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaAQBZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 20:25:16 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43101 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaAQBZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:25:13 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 0/2] Enable clock controllers on MSM
Date: Thu, 16 Jan 2014 17:25:02 -0800
Message-Id: <1389921904-3777-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add the clock controller nodes, enable the clock drivers
on MSM based platforms, and hook it up enough to get the serial console
working. This is based on the merge of Mike's clk-next branch with
linux-next-20140116. The changes need the clk-next branch because that's
where the DTS include files landed.

Perhaps this can be applied after 3.14-rc1 is out?

Stephen Boyd (2):
  ARM: dts: msm: Add clock controller nodes and hook into uart
  ARM: msm_defconfig: Enable MSM clock drivers

 arch/arm/boot/dts/qcom-msm8660-surf.dts | 11 +++++++++++
 arch/arm/boot/dts/qcom-msm8960-cdp.dts  | 18 ++++++++++++++++++
 arch/arm/boot/dts/qcom-msm8974.dtsi     | 24 ++++++++++++++++++++++++
 arch/arm/configs/msm_defconfig          |  4 ++++
 4 files changed, 57 insertions(+)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

