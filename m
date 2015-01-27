Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbbA0GuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 01:50:04 -0500
Received: from gn237.zone.eu ([217.146.67.237]:31916 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbbA0Gt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 01:49:57 -0500
From: Priit Laes <plaes@plaes.org>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Priit Laes <plaes@plaes.org>
Subject: [PATCH 5/7] rtlwifi: Remove unused defines from cam.h
Date: Tue, 27 Jan 2015 08:49:31 +0200
Message-Id: <1422341373-22196-5-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422341373-22196-1-git-send-email-plaes@plaes.org>
References: <1422341373-22196-1-git-send-email-plaes@plaes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/net/wireless/rtlwifi/cam.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/cam.h b/drivers/net/wireless/rtlwifi/cam.h
index 3550808..e2e647d 100644
--- a/drivers/net/wireless/rtlwifi/cam.h
+++ b/drivers/net/wireless/rtlwifi/cam.h
@@ -28,13 +28,11 @@
 
 #define CAM_CONTENT_COUNT				8
 
-#define CFG_DEFAULT_KEY					BIT(5)
 #define CFG_VALID					BIT(15)
 
 #define PAIRWISE_KEYIDX					0
 #define CAM_PAIRWISE_KEY_POSITION			4
 
-#define	CAM_CONFIG_USEDK				1
 #define	CAM_CONFIG_NO_USEDK				0
 
 void rtl_cam_reset_all_entry(struct ieee80211_hw *hw);
-- 
2.2.2

