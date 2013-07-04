Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699Ab3GDHTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 03:19:37 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:53065 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933644Ab3GDHTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 03:19:36 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 4/4] arm: atmel: sam9n12: enable kernel uncompress info output
Date: Thu,  4 Jul 2013 15:16:42 +0800
Message-Id: <1372922202-28606-5-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372922202-28606-1-git-send-email-voice.shen@atmel.com>
References: <1372922202-28606-1-git-send-email-voice.shen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the sam9n12 use the same array usart as sam9x5, add it which will
enable output kernel uncompress info:
---8>---
Uncompressing Linux... done, booting the kernel.
---<8---

Signed-off-by: Bo Shen <voice.shen@atmel.com>

---
 arch/arm/mach-at91/include/mach/uncompress.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-at91/include/mach/uncompress.h b/arch/arm/mach-at91/include/mach/uncompress.h
index fe097e6..4bb644f 100644
--- a/arch/arm/mach-at91/include/mach/uncompress.h
+++ b/arch/arm/mach-at91/include/mach/uncompress.h
@@ -130,6 +130,7 @@ static inline const u32* decomp_soc_detect(void __iomem *dbgu_base)
 	case ARCH_ID_AT91SAM9RL64:
 		return uarts_sam9rl;
 
+	case ARCH_ID_AT91SAM9N12:
 	case ARCH_ID_AT91SAM9X5:
 		return uarts_sam9x5;
 
-- 
1.7.9.5

