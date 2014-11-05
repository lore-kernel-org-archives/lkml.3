Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbaKERA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:00:28 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:51350 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbaKERAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:00:25 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: [PATCH v4 02/11] ARM: sti: Add two new clock definitions for use with ST's NAND controllers
Date: Wed,  5 Nov 2014 16:59:44 +0000
Message-Id: <1415206793-25670-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415206793-25670-1-git-send-email-lee.jones@linaro.org>
References: <1415206793-25670-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EMISS and NAND Control clocks are used when conducting operations
on attached NAND Flash chips.

Reviewed-by: Pekon Gupta <pekon@pek-sem.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/dt-bindings/clock/stih416-clks.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/dt-bindings/clock/stih416-clks.h b/include/dt-bindings/clock/stih416-clks.h
index f9bdbd1..3a8c979 100644
--- a/include/dt-bindings/clock/stih416-clks.h
+++ b/include/dt-bindings/clock/stih416-clks.h
@@ -7,10 +7,12 @@
 
 /* CLOCKGEN A0 */
 #define CLK_ICN_REG		0
+#define CLK_EMISS		3
 #define CLK_ETH1_PHY		4
 
 /* CLOCKGEN A1 */
 #define CLK_ICN_IF_2		0
 #define CLK_GMAC0_PHY		3
+#define CLK_NAND_CTRL		4
 
 #endif
-- 
1.9.1

