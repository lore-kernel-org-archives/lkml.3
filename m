Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784AbaH0Mmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 08:42:44 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:56530 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257AbaH0Mml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 08:42:41 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: [PATCH 2/9] ARM: sti: Add two new clock definitions for use with ST's NAND controllers
Date: Wed, 27 Aug 2014 13:42:17 +0100
Message-Id: <1409143344-22458-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409143344-22458-1-git-send-email-lee.jones@linaro.org>
References: <1409143344-22458-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EMISS and NAND Control clocks are used when conducting operations
on attached NAND Flash chips.

Reviewed-By: Pekon Gupta <pekon@pek-sem.com>
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

