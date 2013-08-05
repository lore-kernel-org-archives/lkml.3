Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3HEJ72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:59:28 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:41541 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab3HEJ64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:58:56 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, justinmattock@gmail.com,
        ikerpedrosam@gmail.com, mujeeb.adil@gmail.com, harsh1kumar@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] Staging: winbond: mds_f: deleted extern function
Date: Mon,  5 Aug 2013 11:58:32 +0200
Message-Id: <1375696712-5276-7-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375696712-5276-1-git-send-email-ikerpedrosam@gmail.com>
References: <1375696712-5276-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deleted an extern function that wasn't used in this driver.

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/mds_f.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/winbond/mds_f.h b/drivers/staging/winbond/mds_f.h
index ce5a78c..159b2eb 100644
--- a/drivers/staging/winbond/mds_f.h
+++ b/drivers/staging/winbond/mds_f.h
@@ -9,7 +9,6 @@ void Mds_Tx(struct wbsoft_priv *adapter);
 void Mds_SendComplete(struct wbsoft_priv *adapter, struct T02_descriptor *pt02);
 void Mds_MpduProcess(struct wbsoft_priv *adapter,
 		     struct wb35_descriptor *prxdes);
-extern void DataDmp(u8 *pdata, u32 len, u32 offset);
 
 /* For data frame sending */
 u16 MDS_GetPacketSize(struct wbsoft_priv *adapter);
-- 
1.8.1.2

