Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaEGECW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:02:22 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:40604 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaEGECT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:02:19 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 13/13] staging: rtl8188eu: Remove 'u8 fragcnt' from struct recv_frame
Date: Wed,  7 May 2014 09:31:18 +0530
Message-Id: <1399435278-32602-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399435278-32602-1-git-send-email-navin.patidar@gmail.com>
References: <1399435278-32602-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused variable 'u8 fragcnt'.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_recv.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index b0fbdbd..f0c26ef 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -253,7 +253,6 @@ struct recv_frame {
 	struct sk_buff	 *pkt;
 	struct sk_buff	 *pkt_newalloc;
 	struct adapter  *adapter;
-	u8 fragcnt;
 	struct rx_pkt_attrib attrib;
 	uint  len;
 	u8 *rx_head;
-- 
1.7.10.4

