Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaJZQAJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 12:00:09 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38545 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaJZQAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 12:00:03 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
        Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net
Subject: [PATCH] staging: rtl8723au pointer issue
Date: Sun, 26 Oct 2014 15:59:56 +0000
Message-Id: <1414339196-4139-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: "foo*bar" should be "foo *bar"

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_cmd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
index 4eaa502..fef5841 100644
--- a/drivers/staging/rtl8723au/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
@@ -599,7 +599,7 @@ exit:
 	return res;
 }
 
-int rtw_disassoc_cmd23a(struct rtw_adapter*padapter, u32 deauth_timeout_ms,
+int rtw_disassoc_cmd23a(struct rtw_adapter *padapter, u32 deauth_timeout_ms,
 			bool enqueue)
 {
 	struct cmd_obj *cmdobj = NULL;
@@ -786,7 +786,7 @@ exit:
 	return res;
 }
 
-int rtw_addbareq_cmd23a(struct rtw_adapter*padapter, u8 tid, u8 *addr)
+int rtw_addbareq_cmd23a(struct rtw_adapter *padapter, u8 tid, u8 *addr)
 {
 	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
 	struct cmd_obj *ph2c;
@@ -822,7 +822,7 @@ exit:
 	return res;
 }
 
-int rtw_dynamic_chk_wk_cmd23a(struct rtw_adapter*padapter)
+int rtw_dynamic_chk_wk_cmd23a(struct rtw_adapter *padapter)
 {
 	struct cmd_obj *ph2c;
 	struct drvextra_cmd_parm *pdrvextra_cmd_parm;
@@ -859,7 +859,7 @@ exit:
  * This is only ever called from on_action_spct23a_ch_switch () which isn't
  * called from anywhere itself
  */
-int rtw_set_ch_cmd23a(struct rtw_adapter*padapter, u8 ch, u8 bw, u8 ch_offset,
+int rtw_set_ch_cmd23a(struct rtw_adapter *padapter, u8 ch, u8 bw, u8 ch_offset,
 		      u8 enqueue)
 {
 	struct cmd_obj *pcmdobj;
@@ -1098,7 +1098,7 @@ exit:
 	return res;
 }
 
-int rtw_ps_cmd23a(struct rtw_adapter*padapter)
+int rtw_ps_cmd23a(struct rtw_adapter *padapter)
 {
 	struct cmd_obj *ppscmd;
 	struct drvextra_cmd_parm *pdrvextra_cmd_parm;
@@ -1168,7 +1168,7 @@ static void rtw_chk_hi_queue_hdl(struct rtw_adapter *padapter)
 	}
 }
 
-int rtw_chk_hi_queue_cmd23a(struct rtw_adapter*padapter)
+int rtw_chk_hi_queue_cmd23a(struct rtw_adapter *padapter)
 {
 	struct cmd_obj *ph2c;
 	struct drvextra_cmd_parm *pdrvextra_cmd_parm;
-- 
1.9.1

