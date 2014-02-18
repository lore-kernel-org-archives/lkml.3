Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbaBROFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:05:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917AbaBROFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:05:30 -0500
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Franky Lin <frankyl@broadcom.com>, Arend van Spriel <arend@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH] drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c: deinline brcmf_sdio_chip_cr4_enterdl, save 440 bytes
Date: Tue, 18 Feb 2014 15:05:20 +0100
Message-Id: <1392732320-18973-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 82bf3c5..b810ab5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -900,7 +900,7 @@ static bool brcmf_sdio_chip_cm3_exitdl(struct brcmf_sdio_dev *sdiodev,
 	return true;
 }
 
-static inline void
+static void
 brcmf_sdio_chip_cr4_enterdl(struct brcmf_sdio_dev *sdiodev,
 			    struct brcmf_chip *ci)
 {
-- 
1.8.1.4

