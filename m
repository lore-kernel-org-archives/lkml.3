Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbbAVQOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:14:37 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47662 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbbAVQO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:14:27 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v12 5/6] clkdev: Export clk_register_clkdev
Date: Thu, 22 Jan 2015 17:13:15 +0100
Message-Id: <1421943207-5180-6-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421943207-5180-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1421943207-5180-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it can be used from modules such as clk-test.ko.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/clk/clkdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index fac3244..667ce38 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -379,6 +379,7 @@ int clk_register_clkdev(struct clk *clk, const char *con_id,
 
 	return 0;
 }
+EXPORT_SYMBOL(clk_register_clkdev);
 
 /**
  * clk_register_clkdevs - register a set of clk_lookup for a struct clk
-- 
1.9.3

