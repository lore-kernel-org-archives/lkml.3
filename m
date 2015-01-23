Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbbAWLEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:04:42 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:52325 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbbAWLEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:04:39 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v13 5/6] clkdev: Export clk_register_clkdev
Date: Fri, 23 Jan 2015 12:03:32 +0100
Message-Id: <1422011024-32283-6-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422011024-32283-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1422011024-32283-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it can be used from modules such as clk-test.ko.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clkdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 901d242..29a1ab7 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -377,6 +377,7 @@ int clk_register_clkdev(struct clk *clk, const char *con_id,
 
 	return 0;
 }
+EXPORT_SYMBOL(clk_register_clkdev);
 
 /**
  * clk_register_clkdevs - register a set of clk_lookup for a struct clk
-- 
1.9.3

