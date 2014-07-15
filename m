Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbaGOW7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:59:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45435 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbaGOW7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 18:59:45 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Rob Clark <robdclark@gmail.com>
Subject: [PATCH 0/2] APQ8064 multimedia clock driver
Date: Tue, 15 Jul 2014 15:59:40 -0700
Message-Id: <1405465182-925-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches add support for the APQ8064 multimedia clock
controller. They rely on a couple other patches to this
driver[1][2].

Stephen Boyd (2):
  clk: qcom: pll: Add support for configuring SR PLLs
  clk: qcom: Add support for APQ8064 multimedia clocks

 .../devicetree/bindings/clock/qcom,mmcc.txt        |   1 +
 drivers/clk/qcom/clk-pll.c                         |  15 +-
 drivers/clk/qcom/clk-pll.h                         |   2 +
 drivers/clk/qcom/mmcc-msm8960.c                    | 433 ++++++++++++++++++++-
 include/dt-bindings/clock/qcom,mmcc-msm8960.h      |   8 +
 include/dt-bindings/reset/qcom,mmcc-msm8960.h      |   8 +
 6 files changed, 462 insertions(+), 5 deletions(-)

[1] https://patchwork.kernel.org/patch/4561071/
[2] https://patchwork.kernel.org/patch/4510951/

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

