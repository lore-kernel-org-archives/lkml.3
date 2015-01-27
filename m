Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbbA0Gui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 01:50:38 -0500
Received: from gn237.zone.eu ([217.146.67.237]:31951 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbbA0GuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 01:50:00 -0500
From: Priit Laes <plaes@plaes.org>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Priit Laes <plaes@plaes.org>
Subject: [PATCH 6/7] rtlwifi: Remove unused defines from base.h
Date: Tue, 27 Jan 2015 08:49:32 +0200
Message-Id: <1422341373-22196-6-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422341373-22196-1-git-send-email-plaes@plaes.org>
References: <1422341373-22196-1-git-send-email-plaes@plaes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/net/wireless/rtlwifi/base.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.h b/drivers/net/wireless/rtlwifi/base.h
index 982f245..ea3e3fc 100644
--- a/drivers/net/wireless/rtlwifi/base.h
+++ b/drivers/net/wireless/rtlwifi/base.h
@@ -45,9 +45,6 @@ enum ap_peer {
 #define RTL_TX_DESC_SIZE	32
 #define RTL_TX_HEADER_SIZE	(RTL_TX_DESC_SIZE + RTL_TX_DUMMY_SIZE)
 
-#define HT_AMSDU_SIZE_4K	3839
-#define HT_AMSDU_SIZE_8K	7935
-
 #define MAX_BIT_RATE_40MHZ_MCS15	300	/* Mbps */
 #define MAX_BIT_RATE_40MHZ_MCS7		150	/* Mbps */
 
@@ -61,9 +58,6 @@ enum ap_peer {
 #define MAX_BIT_RATE_LONG_GI_1NSS_80MHZ_MCS9	390	/* Mbps */
 #define MAX_BIT_RATE_LONG_GI_1NSS_80MHZ_MCS7	293	/* Mbps */
 
-#define RTL_RATE_COUNT_LEGACY		12
-#define RTL_CHANNEL_COUNT		14
-
 #define FRAME_OFFSET_FRAME_CONTROL	0
 #define FRAME_OFFSET_DURATION		2
 #define FRAME_OFFSET_ADDRESS1		4
-- 
2.2.2

