Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaLTMUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 07:20:20 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:51334 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbaLTMUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 07:20:17 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        navin patidar <navin.patidar@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8188eu: core: rtw_mlme_ext.c:  Remove unused function
Date: Sat, 20 Dec 2014 13:23:03 +0100
Message-Id: <1419078183-30635-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function NULL_hdl() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c    |    5 -----
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h |    1 -
 2 files changed, 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index 5ba5099..1e6993b 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -4926,11 +4926,6 @@ void addba_timer_hdl(void *function_context)
 	}
 }
 
-u8 NULL_hdl(struct adapter *padapter, u8 *pbuf)
-{
-	return H2C_SUCCESS;
-}
-
 u8 setopmode_hdl(struct adapter *padapter, u8 *pbuf)
 {
 	u8 type;
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
index d699ca1..4f87160 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
@@ -679,7 +679,6 @@ u8 read_bbreg_hdl(struct adapter *padapter, u8 *pbuf);
 u8 write_bbreg_hdl(struct adapter *padapter, u8 *pbuf);
 u8 read_rfreg_hdl(struct adapter *padapter, u8 *pbuf);
 u8 write_rfreg_hdl(struct adapter *padapter, u8 *pbuf);
-u8 NULL_hdl(struct adapter *padapter, u8 *pbuf);
 u8 join_cmd_hdl(struct adapter *padapter, u8 *pbuf);
 u8 disconnect_hdl(struct adapter *padapter, u8 *pbuf);
 u8 createbss_hdl(struct adapter *padapter, u8 *pbuf);
-- 
1.7.10.4

