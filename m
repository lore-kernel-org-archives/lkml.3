Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbaCZXGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 19:06:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37636 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248AbaCZXGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 19:06:41 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/3] CCF fixlets
Date: Wed, 26 Mar 2014 16:06:34 -0700
Message-Id: <1395875197-16816-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two small changes to clean up the code plus a change to make
driver code simpler.

Stephen Boyd (3):
  clk: Don't check for missing ops in clk_set_parent()
  clk: Consolidate recalc rate logic
  clk: Ignore error and NULL pointers passed to
    clk_{unprepare,disable}()

 drivers/clk/clk.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

