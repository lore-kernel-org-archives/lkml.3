Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbaICHNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:13:36 -0400
Received: from srv-hp10.netsons.net ([94.141.22.72]:44762 "EHLO
	srv-hp10.netsons.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755528AbaICHNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:13:35 -0400
X-Greylist: delayed 2654 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Sep 2014 03:13:34 EDT
From: Luca Ceresoli <luca@lucaceresoli.net>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, Luca Ceresoli <luca@lucaceresoli.net>,
        Greg Kroah-Hartman <gregkh@linux.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] staging: rtl8188eu: fix missing blank lines after declarations
Date: Wed,  3 Sep 2014 08:28:21 +0200
Message-Id: <1409725701-4594-1-git-send-email-luca@lucaceresoli.net>
X-Mailer: git-send-email 1.9.1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv-hp10.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: srv-hp10.netsons.net: authenticated_id: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Greg Kroah-Hartman <gregkh@linux.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 104b01f..71bd508 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -98,6 +98,7 @@ static int rtw_cmd_filter(struct cmd_priv *pcmdpriv, struct cmd_obj *cmd_obj)
 	    (!pcmdpriv->padapter->registrypriv.usbss_enable)) {
 		if (cmd_obj->cmdcode == GEN_CMD_CODE(_Set_Drv_Extra)) {
 			struct drvextra_cmd_parm	*pdrvextra_cmd_parm = (struct drvextra_cmd_parm	*)cmd_obj->parmbuf;
+
 			if (pdrvextra_cmd_parm->ec_id == POWER_SAVING_CTRL_WK_CID)
 				bAllow = true;
 		}
@@ -296,6 +297,7 @@ u8 rtw_sitesurvey_cmd(struct adapter  *padapter, struct ndis_802_11_ssid *ssid,
 	/* prepare ssid list */
 	if (ssid) {
 		int i;
+
 		for (i = 0; i < ssid_num && i < RTW_SSID_SCAN_AMOUNT; i++) {
 			if (ssid[i].SsidLength) {
 				memcpy(&psurveyPara->ssid[i], &ssid[i], sizeof(struct ndis_802_11_ssid));
@@ -307,6 +309,7 @@ u8 rtw_sitesurvey_cmd(struct adapter  *padapter, struct ndis_802_11_ssid *ssid,
 	/* prepare channel list */
 	if (ch) {
 		int i;
+
 		for (i = 0; i < ch_num && i < RTW_CHANNEL_SCAN_AMOUNT; i++) {
 			if (ch[i].hw_value && !(ch[i].flags & RTW_IEEE80211_CHAN_DISABLED)) {
 				memcpy(&psurveyPara->ch[i], &ch[i], sizeof(struct rtw_ieee80211_channel));
-- 
1.9.1

