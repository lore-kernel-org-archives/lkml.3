Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaJSPlP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 11:41:15 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:51849 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaJSPlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 11:41:04 -0400
Message-ID: <1413733260.6272.1.camel@phoenix>
Subject: [PATCH] soc: versatile: Add terminating entry for
 realview_soc_of_match
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 19 Oct 2014 23:41:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/soc/versatile/soc-realview.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/versatile/soc-realview.c b/drivers/soc/versatile/soc-realview.c
index cea8ea3..1a07bf5 100644
--- a/drivers/soc/versatile/soc-realview.c
+++ b/drivers/soc/versatile/soc-realview.c
@@ -26,6 +26,7 @@ static const struct of_device_id realview_soc_of_match[] = {
 	{ .compatible = "arm,realview-pb11mp-soc", },
 	{ .compatible = "arm,realview-pba8-soc", },
 	{ .compatible = "arm,realview-pbx-soc", },
+	{ }
 };
 
 static u32 realview_coreid;
-- 
1.9.1



