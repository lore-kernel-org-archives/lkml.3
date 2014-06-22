Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaFVIwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:52:22 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:54608 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaFVIwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:52:18 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 33/42] staging: rtl8188eu: osdep_service.h: Remove unused function definations
Date: Sun, 22 Jun 2014 14:21:37 +0530
Message-Id: <1403427107-12744-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
References: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_service.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 1fb92c6..0b3066c 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -159,8 +159,6 @@ u8 *_rtw_malloc(u32 sz);
 
 void *rtw_malloc2d(int h, int w, int size);
 
-void _rtw_memcpy(void *dec, void *sour, u32 sz);
-
 u32  _rtw_down_sema(struct semaphore *sema);
 
 void _rtw_init_queue(struct __queue *pqueue);
@@ -260,6 +258,5 @@ bool rtw_cbuf_empty(struct rtw_cbuf *cbuf);
 bool rtw_cbuf_push(struct rtw_cbuf *cbuf, void *buf);
 void *rtw_cbuf_pop(struct rtw_cbuf *cbuf);
 struct rtw_cbuf *rtw_cbuf_alloc(u32 size);
-int wifirate2_ratetbl_inx(unsigned char rate);
 
 #endif
-- 
1.7.10.4

