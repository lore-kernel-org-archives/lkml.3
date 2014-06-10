Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbaFJU6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:58:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43033 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbaFJU63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:58:29 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 0/2] Support apq8064 global clock control
Date: Tue, 10 Jun 2014 13:58:24 -0700
Message-Id: <1402433906-19309-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches add full support for apq8064 in the global clock
controller driver. The first patch has already been on the list so
I've picked it up and resent because the second patch depends on it.

Srinivas Kandagatla (1):
  clk: qcom: add clocks necessary for apq8064 sdcc

Stephen Boyd (1):
  clk: qcom: Fully support apq8064 global clock control

 drivers/clk/qcom/gcc-msm8960.c               | 583 ++++++++++++++++++++++++++-
 include/dt-bindings/clock/qcom,gcc-msm8960.h |  11 +
 include/dt-bindings/reset/qcom,gcc-msm8960.h |  16 +
 3 files changed, 607 insertions(+), 3 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

