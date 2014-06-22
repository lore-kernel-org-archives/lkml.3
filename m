Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaFVIVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:21:24 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:47720 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaFVIVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:21:13 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 02/42] staging: rtl8188eu: Remove dummy function CheckFwRsvdPageContent()
Date: Sun, 22 Jun 2014 13:49:22 +0530
Message-Id: <1403425202-11942-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
References: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c     |    6 ------
 drivers/staging/rtl8188eu/include/rtl8188e_cmd.h |    1 -
 2 files changed, 7 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
index 5c9d64e..fe8ba7e 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c
@@ -476,12 +476,6 @@ static void ConstructProbeRsp(struct adapter *adapt, u8 *pframe, u32 *pLength, u
 	*pLength = pktlen;
 }
 
-/*  To check if reserved page content is destroyed by beacon because beacon is too large. */
-/*  2010.06.23. Added by tynli. */
-void CheckFwRsvdPageContent(struct adapter *Adapter)
-{
-}
-
 /*  */
 /*  Description: Fill the reserved packets that FW will use to RSVD page. */
 /*			Now we just send 4 types packet to rsvd page. */
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_cmd.h b/drivers/staging/rtl8188eu/include/rtl8188e_cmd.h
index b32bc28..4601169 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_cmd.h
@@ -116,7 +116,6 @@ void rtl8188e_Add_RateATid(struct adapter *padapter, u32 bitmap, u8 arg,
 void rtl8188e_set_p2p_ps_offload_cmd(struct adapter *adapt, u8 p2p_ps_state);
 #endif /* CONFIG_88EU_P2P */
 
-void CheckFwRsvdPageContent(struct adapter *adapt);
 void rtl8188e_set_FwMediaStatus_cmd(struct adapter *adapt, __le16 mstatus_rpt);
 
 #endif/* __RTL8188E_CMD_H__ */
-- 
1.7.10.4

