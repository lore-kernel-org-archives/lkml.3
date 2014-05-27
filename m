Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaE0Ljf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:39:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37690 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751747AbaE0Ljc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:39:32 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH] MAINTAINERS: add AT91 Clock Support entry
Date: Tue, 27 May 2014 13:39:28 +0200
Message-Id: <1401190768-3932-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1066264..40c5580 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -808,6 +808,11 @@ F:	arch/arm/boot/dts/at91*.dtsi
 F:	arch/arm/boot/dts/sama*.dts
 F:	arch/arm/boot/dts/sama*.dtsi
 
+ARM/ATMEL AT91 Clock Support
+M:	Boris Brezillon <boris.brezillon@free-electrons.com>
+S:	Maintained
+F:	drivers/clk/at91
+
 ARM/CALXEDA HIGHBANK ARCHITECTURE
 M:	Rob Herring <robh@kernel.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-- 
1.8.3.2

