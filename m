Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaEGEBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:01:45 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:52553 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaEGEBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:01:43 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 10/13] staging: rtl8188eu: Remove unused inline function get_rx_status()
Date: Wed,  7 May 2014 09:31:15 +0530
Message-Id: <1399435278-32602-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399435278-32602-1-git-send-email-navin.patidar@gmail.com>
References: <1399435278-32602-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_recv.h |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index e5b4e10..dac2e0c 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -291,11 +291,6 @@ static inline u8 *get_rxmem(struct recv_frame *precvframe)
 	return precvframe->rx_head;
 }
 
-static inline u8 *get_rx_status(struct recv_frame *precvframe)
-{
-	return get_rxmem(precvframe);
-}
-
 static inline u8 *recvframe_pull(struct recv_frame *precvframe, int sz)
 {
 	/*  rx_data += sz; move rx_data sz bytes  hereafter */
-- 
1.7.10.4

