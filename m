Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbaBGNKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:10:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41658 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142AbaBGLsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        David Binderman <dcb314@hotmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 056/233] rtlwifi: rtl8188ee: Fix typo in code
Date: Fri,  7 Feb 2014 11:44:35 +0000
Message-Id: <1391773652-25214-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit f699273d6a624266ebc9198774f06ee64a3847a1 upstream.

The static analyser "cppcheck" shows the following typo:
drivers/net/wireless/rtlwifi/rtl8188ee/dm.c:1081]: (style) Same expression on both sides of '!='.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: David Binderman <dcb314@hotmail.com>
Cc: David Binderman <dcb314@hotmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8188ee/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/dm.c b/drivers/net/wireless/rtlwifi/rtl8188ee/dm.c
index 21a5cf0..a6184b6 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/dm.c
@@ -1078,7 +1078,7 @@ static void rtl88e_dm_txpower_tracking_callback_thermalmeter(struct ieee80211_hw
 				rtldm->swing_flag_ofdm = true;
 			}
 
-			if (rtldm->swing_idx_cck != rtldm->swing_idx_cck) {
+			if (rtldm->swing_idx_cck_cur != rtldm->swing_idx_cck) {
 				rtldm->swing_idx_cck_cur = rtldm->swing_idx_cck;
 				rtldm->swing_flag_cck = true;
 			}
-- 
1.8.3.2

