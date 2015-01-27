Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbbA0GuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 01:50:08 -0500
Received: from gn237.zone.eu ([217.146.67.237]:32004 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbbA0GuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 01:50:04 -0500
From: Priit Laes <plaes@plaes.org>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Priit Laes <plaes@plaes.org>
Subject: [PATCH 7/7] rtlwifi: Remove unused defines from efuse.h
Date: Tue, 27 Jan 2015 08:49:33 +0200
Message-Id: <1422341373-22196-7-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422341373-22196-1-git-send-email-plaes@plaes.org>
References: <1422341373-22196-1-git-send-email-plaes@plaes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/net/wireless/rtlwifi/efuse.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/efuse.h b/drivers/net/wireless/rtlwifi/efuse.h
index fdab824..be02e78 100644
--- a/drivers/net/wireless/rtlwifi/efuse.h
+++ b/drivers/net/wireless/rtlwifi/efuse.h
@@ -40,12 +40,6 @@
 #define PG_STATE_WORD_3			0x10
 #define PG_STATE_DATA			0x20
 
-#define PG_SWBYTE_H			0x01
-#define PG_SWBYTE_L			0x02
-
-#define _POWERON_DELAY_
-#define _PRE_EXECUTE_READ_CMD_
-
 #define EFUSE_REPEAT_THRESHOLD_		3
 #define EFUSE_ERROE_HANDLE		1
 
-- 
2.2.2

