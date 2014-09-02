Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaIBHuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 03:50:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35628 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751421AbaIBHuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 03:50:23 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ga=C3=ABl=20PORTAY?= <gael.portay@gmail.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 1/5] clk: at91: fix PLL_MAX_COUNT macro definition
Date: Tue,  2 Sep 2014 09:50:14 +0200
Message-Id: <1409644218-13677-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409644218-13677-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1409644218-13677-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Reported-by: Gaël PORTAY <gael.portay@gmail.com>
---
 drivers/clk/at91/clk-pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/at91/clk-pll.c b/drivers/clk/at91/clk-pll.c
index cf6ed02..7b453b9 100644
--- a/drivers/clk/at91/clk-pll.c
+++ b/drivers/clk/at91/clk-pll.c
@@ -31,7 +31,7 @@
 				 (layout)->mul_mask)
 #define PLL_ICPR_SHIFT(id)	((id) * 16)
 #define PLL_ICPR_MASK(id)	(0xffff << PLL_ICPR_SHIFT(id))
-#define PLL_MAX_COUNT		0x3ff
+#define PLL_MAX_COUNT		0x3f
 #define PLL_COUNT_SHIFT		8
 #define PLL_OUT_SHIFT		14
 #define PLL_MAX_ID		1
-- 
1.9.1

