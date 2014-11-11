Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaKKHyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 02:54:55 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:49113 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaKKHyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 02:54:54 -0500
From: Sanjeev Sharma <sanjeev_sharma@mentor.com>
To: <Larry.Finger@lwfinger.net>, <Jes.Sorensen@redhat.com>
CC: <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: [PATCH] staging:rtl8723au: core: Added missing space reported by checkpatch.
Date: Tue, 11 Nov 2014 13:24:43 +0530
Message-ID: <1415692483-29819-1-git-send-email-sanjeev_sharma@mentor.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <wrfjy4rxzk5b.fsf@redhat.com>
References: <wrfjy4rxzk5b.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the rtw_cmd.c file that fixes following
Error.

ERROR: spaces required around that '>' (ctx:WxV)

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
 drivers/staging/rtl8723au/core/rtw_cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
index 4eaa502..cd2e915 100644
--- a/drivers/staging/rtl8723au/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
@@ -957,7 +957,7 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
 		/*  check traffic for  powersaving. */
 			if (((pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod +
 			      pmlmepriv->LinkDetectInfo.NumTxOkInPeriod) > 8) ||
-			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod >2)
+			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod > 2)
 				bEnterPS = false;
 			else
 				bEnterPS = true;
@@ -1152,7 +1152,7 @@ static void rtw_chk_hi_queue_hdl(struct rtw_adapter *padapter)
 
 			cnt++;
 
-			if (cnt>10)
+			if (cnt > 10)
 				break;
 
 			val = rtl8723a_chk_hi_queue_empty(padapter);
-- 
1.7.11.7

