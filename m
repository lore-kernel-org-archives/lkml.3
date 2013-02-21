Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991Ab3BUUmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 15:42:43 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:45777 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab3BUU0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 15:26:41 -0500
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org
Subject: [PATCH] media/usb: cx231xx-pcb-cfg.h: Remove unused enum _true_false.
Date: Thu, 21 Feb 2013 17:18:16 -0300
Message-Id: <1361477896-22633-1-git-send-email-tfarina@chromium.org>
X-Mailer: git-send-email 1.8.1.151.g32238ae
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thiago Farina <tfarina@chromium.org>
---
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h
index f5e46e8..b3c6190 100644
--- a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h
+++ b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h
@@ -68,11 +68,6 @@ enum USB_SPEED{
 	HIGH_SPEED = 0x1	/* 1: high speed */
 };
 
-enum _true_false{
-	FALSE = 0,
-	TRUE = 1
-};
-
 #define TS_MASK         0x6
 enum TS_PORT{
 	NO_TS_PORT = 0x0,	/* 2'b00: Neither port used. PCB not a Hybrid,
-- 
1.8.1.151.g32238ae

