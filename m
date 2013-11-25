Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab3KYVqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:46:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50884 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520Ab3KYVpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:45:13 -0500
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 7/7] OMAP: AM33xx: hwmod: Correct AES module SYSC type
Date: Mon, 25 Nov 2013 15:44:36 -0600
Message-ID: <1385415876-12387-8-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385415876-12387-1-git-send-email-joelf@ti.com>
References: <1385415876-12387-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly added sysc type4 for AES module.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c b/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c
index 0f17862..7f97863 100644
--- a/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c
@@ -209,6 +209,7 @@ static struct omap_hwmod_class_sysconfig am33xx_aes0_sysc = {
 	.sysc_offs	= 0x84,
 	.syss_offs	= 0x88,
 	.sysc_flags	= SYSS_HAS_RESET_STATUS,
+	.sysc_fields    = &omap_hwmod_sysc_type4,
 };
 
 static struct omap_hwmod_class am33xx_aes0_hwmod_class = {
-- 
1.8.1.2

