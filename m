Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711AbaDIN6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:58:51 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60850 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933389AbaDINvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:51:32 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 06/15] clk: sunxi: add A31 APB0 gates compatible string to the documentation
Date: Wed,  9 Apr 2014 15:51:09 +0200
Message-Id: <1397051478-4113-7-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new "allwinner,sun6i-a31-apb0-gates-clk" compatible string to the
sunxi clock documentation.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 Documentation/devicetree/bindings/clock/sunxi.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Documentation/devicetree/bindings/clock/sunxi.txt
index c2cb762..bc30387 100644
--- a/Documentation/devicetree/bindings/clock/sunxi.txt
+++ b/Documentation/devicetree/bindings/clock/sunxi.txt
@@ -25,6 +25,7 @@ Required properties:
 	"allwinner,sun4i-apb0-gates-clk" - for the APB0 gates on A10
 	"allwinner,sun5i-a13-apb0-gates-clk" - for the APB0 gates on A13
 	"allwinner,sun5i-a10s-apb0-gates-clk" - for the APB0 gates on A10s
+	"allwinner,sun6i-a31-apb0-gates-clk" - for the APB0 gates on A10s
 	"allwinner,sun7i-a20-apb0-gates-clk" - for the APB0 gates on A20
 	"allwinner,sun4i-apb1-clk" - for the APB1 clock
 	"allwinner,sun4i-apb1-mux-clk" - for the APB1 clock muxing
-- 
1.8.3.2

