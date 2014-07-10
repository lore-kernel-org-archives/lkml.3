Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaGJIRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:17:24 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53087 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaGJIRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:17:10 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 0/2] Support apq8064 global clock control
Date: Thu, 10 Jul 2014 09:16:33 +0100
Message-Id: <1404980193-5967-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402433906-19309-1-git-send-email-sboyd@codeaurora.org>
References: <1402433906-19309-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches add full support for apq8064 in the global clock
controller driver. The first patch has already been on the list so
I've picked it up and resent because the second patch depends on it.

Am resending the series with the fix to my patch.

Changes since v1:
	- fixed comment log spotted by Andreas.
	- added few more sdcc clocks.

Srinivas Kandagatla (1):
  clk: qcom: add clocks necessary for apq8064 sdcc

Stephen Boyd (1):
  clk: qcom: Fully support apq8064 global clock control

 drivers/clk/qcom/gcc-msm8960.c               | 583 ++++++++++++++++++++++++++-
 include/dt-bindings/clock/qcom,gcc-msm8960.h |  11 +
 include/dt-bindings/reset/qcom,gcc-msm8960.h |  16 +
 3 files changed, 607 insertions(+), 3 deletions(-)

-- 
1.9.1

