Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbaDRX3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 19:29:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56785 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaDRX3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 19:29:46 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] Clock unregistration fixes
Date: Fri, 18 Apr 2014 16:29:41 -0700
Message-Id: <1397863783-10728-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two fixes for fallout from commit fcb0ee6a3d33 (clk: Implement clk_unregister).

Stephen Boyd (2):
  clk: Fix double free due to devm_clk_register()
  clk: Fix slab corruption in clk_unregister()

 drivers/clk/clk.c | 74 ++++++++++++++++++++++++-------------------------------
 1 file changed, 32 insertions(+), 42 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

