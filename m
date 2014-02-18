Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbaBROFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:05:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810AbaBROFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:05:50 -0500
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Franky Lin <frankyl@broadcom.com>, Arend van Spriel <arend@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH] drivers/net/wireless/brcm80211/brcmsmac/main.c: deinline wlc_intstatus, save 429 bytes
Date: Tue, 18 Feb 2014 15:05:44 +0100
Message-Id: <1392732344-26119-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 9417cb5..fa7bc18 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -2539,7 +2539,7 @@ brcms_c_mute(struct brcms_c_info *wlc, bool mute_tx)
  *   0 if the interrupt is not for us, or we are in some special cases;
  *   device interrupt status bits otherwise.
  */
-static inline u32 wlc_intstatus(struct brcms_c_info *wlc, bool in_isr)
+static u32 wlc_intstatus(struct brcms_c_info *wlc, bool in_isr)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
 	struct bcma_device *core = wlc_hw->d11core;
-- 
1.8.1.4

