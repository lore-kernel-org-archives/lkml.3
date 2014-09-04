Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbaIDUto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:49:44 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:50801 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbaIDUtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:49:43 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <gregkh@linux.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: rtl8723au: Fix "space required before that '*'" errors
Date: Thu,  4 Sep 2014 15:49:30 -0500
Message-Id: <1409863770-22622-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl "space required before that '*'" errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_recv.c     | 2 +-
 drivers/staging/rtl8723au/core/rtw_security.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index 0cdcd12..5138ea0 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -282,7 +282,7 @@ int recvframe_chkmic(struct rtw_adapter *adapter,
 	u32	datalen;
 	u8	miccode[8];
 	u8	bmic_err = false, brpt_micerror = true;
-	u8	*pframe, *payload,*pframemic;
+	u8	*pframe, *payload, *pframemic;
 	u8	*mickey;
 	/* u8	*iv, rxdata_key_idx = 0; */
 	struct	sta_info *stainfo;
diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index d6c07ad..0fea2e4 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -623,7 +623,7 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 	struct arc4context mycontext;
 	int			curfragnum, length;
 	u32	prwskeylen;
-	u8	*pframe, *payload,*iv,*prwskey;
+	u8	*pframe, *payload, *iv, *prwskey;
 	union pn48 dot11txpn;
 	struct	sta_info		*stainfo;
 	struct	pkt_attrib	 *pattrib = &pxmitframe->attrib;
@@ -723,7 +723,7 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 	struct arc4context mycontext;
 	int	length;
 	u32	prwskeylen;
-	u8	*pframe, *payload,*iv,*prwskey;
+	u8	*pframe, *payload, *iv, *prwskey;
 	union pn48 dot11txpn;
 	struct	sta_info		*stainfo;
 	struct	rx_pkt_attrib *prxattrib = &precvframe->attrib;
-- 
1.9.1

