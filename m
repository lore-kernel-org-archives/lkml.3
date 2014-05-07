Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaEGECM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:02:12 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:63918 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbaEGECH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:02:07 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 12/13] staging: rtl8188eu: Remove 'int frame_tag' from struct recv_frame
Date: Wed,  7 May 2014 09:31:17 +0530
Message-Id: <1399435278-32602-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399435278-32602-1-git-send-email-navin.patidar@gmail.com>
References: <1399435278-32602-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused variable 'int frame_tag'.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_recv.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index e14ba98..b0fbdbd 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -254,7 +254,6 @@ struct recv_frame {
 	struct sk_buff	 *pkt_newalloc;
 	struct adapter  *adapter;
 	u8 fragcnt;
-	int frame_tag;
 	struct rx_pkt_attrib attrib;
 	uint  len;
 	u8 *rx_head;
-- 
1.7.10.4

