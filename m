Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab3J1SCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 14:02:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40695 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab3J1SCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 14:02:09 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/6] Enable clock controllers on MSM
Date: Mon, 28 Oct 2013 11:01:58 -0700
Message-Id: <1382983324-31155-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.1.600.g3d092bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset enables the clock controller hardware on some DT based
MSM devices. It also hooks up the 8974 SoC's serial device to the
clock controller so that we can get a serial console.

This patchset is based on Rohit's 8974 patches[1] and my follow up
dts update patches[2]. For it to be fully functional you'll also need
to apply the MSM clock driver patches[3] or wait for them to land in
linux-next.

Stephen Boyd (6):
  ARM: dts: msm: Add MSM8960 GCC DT node
  ARM: dts: msm: Add MSM8960 MMCC DT node
  ARM: dts: msm: Add clock entries for MSM8960 uart device
  ARM: dts: msm: Add MSM8974 GCC node
  ARM: dts: msm: Add MSM8974 serial device node
  ARM: msm_defconfig: Enable MSM clock drivers

 arch/arm/boot/dts/qcom-msm8960-cdp.dts | 18 ++++++++++++++++++
 arch/arm/boot/dts/qcom-msm8974.dtsi    | 17 +++++++++++++++++
 arch/arm/configs/msm_defconfig         |  3 +++
 3 files changed, 38 insertions(+)

[1] https://lkml.org/lkml/2013/10/17/520
[2] https://lkml.org/lkml/2013/10/18/406
[3] http://www.mail-archive.com/linux-arm-msm@vger.kernel.org/msg06742.html
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

