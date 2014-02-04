Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256AbaBDVCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:02:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933180AbaBDVCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:02:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        David Binderman <dcb314@hotmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.10 034/104] rtlwifi: rtl8188ee: Fix typo in code
Date: Tue,  4 Feb 2014 13:01:37 -0800
Message-Id: <20140204210223.700590203@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210222.731641778@linuxfoundation.org>
References: <20140204210222.731641778@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit f699273d6a624266ebc9198774f06ee64a3847a1 upstream.

The static analyser "cppcheck" shows the following typo:
drivers/net/wireless/rtlwifi/rtl8188ee/dm.c:1081]: (style) Same expression on both sides of '!='.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: David Binderman <dcb314@hotmail.com>
Cc: David Binderman <dcb314@hotmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8188ee/dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rtlwifi/rtl8188ee/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/dm.c
@@ -1078,7 +1078,7 @@ static void rtl88e_dm_txpower_tracking_c
 				rtldm->swing_flag_ofdm = true;
 			}
 
-			if (rtldm->swing_idx_cck != rtldm->swing_idx_cck) {
+			if (rtldm->swing_idx_cck_cur != rtldm->swing_idx_cck) {
 				rtldm->swing_idx_cck_cur = rtldm->swing_idx_cck;
 				rtldm->swing_flag_cck = true;
 			}


