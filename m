Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbaBRNhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:37:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084AbaBRNhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:37:39 -0500
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Franky Lin <frankyl@broadcom.com>, Arend van Spriel <arend@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH] drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c: deinline brcmf_sdio_clrintr, save 8979 bytes
Date: Tue, 18 Feb 2014 14:37:27 +0100
Message-Id: <1392730647-5948-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 3e99189..7039edd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2277,7 +2277,7 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 	bus->tx_seq = bus->rx_seq = 0;
 }
 
-static inline void brcmf_sdio_clrintr(struct brcmf_sdio *bus)
+static void brcmf_sdio_clrintr(struct brcmf_sdio *bus)
 {
 	unsigned long flags;
 
-- 
1.8.1.4

