Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbaBROFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:05:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713AbaBROFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:05:39 -0500
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Franky Lin <frankyl@broadcom.com>, Arend van Spriel <arend@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH] drivers/net/wireless/brcm80211/brcmsmac/dma.c: deinline dma64_dd_upd, save 157 bytes
Date: Tue, 18 Feb 2014 15:05:36 +0100
Message-Id: <1392732336-23586-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index 4fb9635..5acf73e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -711,7 +711,7 @@ struct dma_pub *dma_attach(char *name, struct brcms_c_info *wlc,
 	return NULL;
 }
 
-static inline void
+static void
 dma64_dd_upd(struct dma_info *di, struct dma64desc *ddring,
 	     dma_addr_t pa, uint outidx, u32 *flags, u32 bufcount)
 {
-- 
1.8.1.4

