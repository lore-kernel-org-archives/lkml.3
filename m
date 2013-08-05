Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab3HEJ66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:58:58 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:44118 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab3HEJ6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:58:54 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, justinmattock@gmail.com,
        ikerpedrosam@gmail.com, mujeeb.adil@gmail.com, harsh1kumar@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] Staging: winbond: mds_f: fixed lines over 80 characters
Date: Mon,  5 Aug 2013 11:58:31 +0200
Message-Id: <1375696712-5276-6-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375696712-5276-1-git-send-email-ikerpedrosam@gmail.com>
References: <1375696712-5276-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some coding style issues.

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/mds_f.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/winbond/mds_f.h b/drivers/staging/winbond/mds_f.h
index ce8be07..ce5a78c 100644
--- a/drivers/staging/winbond/mds_f.h
+++ b/drivers/staging/winbond/mds_f.h
@@ -7,13 +7,17 @@
 unsigned char Mds_initial(struct wbsoft_priv *adapter);
 void Mds_Tx(struct wbsoft_priv *adapter);
 void Mds_SendComplete(struct wbsoft_priv *adapter, struct T02_descriptor *pt02);
-void Mds_MpduProcess(struct wbsoft_priv *adapter, struct wb35_descriptor *prxdes);
+void Mds_MpduProcess(struct wbsoft_priv *adapter,
+		     struct wb35_descriptor *prxdes);
 extern void DataDmp(u8 *pdata, u32 len, u32 offset);
 
 /* For data frame sending */
 u16 MDS_GetPacketSize(struct wbsoft_priv *adapter);
-void MDS_GetNextPacket(struct wbsoft_priv *adapter, struct wb35_descriptor *pdes);
-void MDS_GetNextPacketComplete(struct wbsoft_priv *adapter, struct wb35_descriptor *pdes);
-void MDS_SendResult(struct wbsoft_priv *adapter, u8 packetid, unsigned char sendok);
+void MDS_GetNextPacket(struct wbsoft_priv *adapter,
+		       struct wb35_descriptor *pdes);
+void MDS_GetNextPacketComplete(struct wbsoft_priv *adapter,
+			       struct wb35_descriptor *pdes);
+void MDS_SendResult(struct wbsoft_priv *adapter, u8 packetid,
+		    unsigned char sendok);
 
 #endif
-- 
1.8.1.2

