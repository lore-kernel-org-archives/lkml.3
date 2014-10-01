Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaJARJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:09:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45391 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaJARJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:09:01 -0400
From: Josh Cartwright <joshc@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Add KPSS watchdog driver to relevant device trees
Date: Wed,  1 Oct 2014 12:03:13 -0500
Message-Id: <cover.1412182773.git.joshc@codeaurora.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the Krait Processor Sub-system (KPSS) Watchdog driver has been pulled
into Wim's tree destined for 3.18, add descriptions of the WDT in the relevant
device trees, and include the driver in qcom_defconfig.

Josh Cartwright (4):
  ARM: qcom: add QCOM_WDT driver to qcom_defconfig
  ARM: qcom: add description of KPSS WDT for IPQ8064
  ARM: qcom: add description of KPSS WDT for APQ8064
  ARM: qcom: add description of KPSS WDT for MSM8960

 arch/arm/boot/dts/qcom-apq8064.dtsi | 15 +++++++++++++++
 arch/arm/boot/dts/qcom-ipq8064.dtsi | 15 +++++++++++++++
 arch/arm/boot/dts/qcom-msm8960.dtsi | 15 +++++++++++++++
 arch/arm/configs/qcom_defconfig     |  2 ++
 4 files changed, 47 insertions(+)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

