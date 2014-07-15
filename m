Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbaGOWmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:42:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42606 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbaGOWmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 18:42:35 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 0/2] qcom clock fixes
Date: Tue, 15 Jul 2014 15:42:29 -0700
Message-Id: <1405464151-16152-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's two small fixes for the qcom clock drivers. Nobody has reported
these as regressions so we can safely wait for 3.17, but I've marked
them with the "Fixes" tag so that stable trees can pick them up as
necessary.

Stephen Boyd (2):
  clk: qcom: Fix PLL rate configurations
  clk: qcom: mdp_lut_clk is a child of mdp_src

 drivers/clk/qcom/common.c       | 39 ++++++++++++++++++++++++++++-----------
 drivers/clk/qcom/common.h       |  6 ++++++
 drivers/clk/qcom/mmcc-msm8960.c |  2 +-
 drivers/clk/qcom/mmcc-msm8974.c | 10 ++++------
 4 files changed, 39 insertions(+), 18 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

