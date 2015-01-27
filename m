Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbbA0GvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 01:51:25 -0500
Received: from gn237.zone.eu ([217.146.67.237]:31874 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbbA0Gty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 01:49:54 -0500
From: Priit Laes <plaes@plaes.org>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Priit Laes <plaes@plaes.org>
Subject: [PATCH 4/7] rtlwifi: Remove unused RTL_SUPPORTED_CTRL_FILTER define
Date: Tue, 27 Jan 2015 08:49:30 +0200
Message-Id: <1422341373-22196-4-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422341373-22196-1-git-send-email-plaes@plaes.org>
References: <1422341373-22196-1-git-send-email-plaes@plaes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/net/wireless/rtlwifi/core.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/core.h b/drivers/net/wireless/rtlwifi/core.h
index 624e1dc..3b37557 100644
--- a/drivers/net/wireless/rtlwifi/core.h
+++ b/drivers/net/wireless/rtlwifi/core.h
@@ -33,8 +33,6 @@
 	FIF_FCSFAIL | \
 	FIF_BCN_PRBRESP_PROMISC)
 
-#define RTL_SUPPORTED_CTRL_FILTER	0xFF
-
 extern const struct ieee80211_ops rtl_ops;
 void rtl_fw_cb(const struct firmware *firmware, void *context);
 void rtl_addr_delay(u32 addr);
-- 
2.2.2

