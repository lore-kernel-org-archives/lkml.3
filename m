Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaG0RgF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 13:36:05 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49641 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbaG0RgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 13:36:03 -0400
From: Sylvain Calador <sylvain.calador@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8821ae: fixed a space coding style issue
Date: Sun, 27 Jul 2014 19:35:48 +0200
Message-Id: <1406482548-10871-1-git-send-email-sylvain.calador@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Sylvain Calador <sylvain.calador@gmail.com>
---
 drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.h b/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.h
index 416d3dda..f10bf1b 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.h
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.h
@@ -151,7 +151,7 @@ void ex_halbtc8192e2ant_media_status_notify(struct btc_coexist *btcoexist,
 void ex_halbtc8192e2ant_special_packet_notify(struct btc_coexist *btcoexist,
 					      u8 type);
 void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
-				       u8 *tmpBuf,u8 length);
+				       u8 *tmpBuf, u8 length);
 void ex_halbtc8192e2ant_stack_operation_notify(struct btc_coexist *btcoexist,
 					       u8 type);
 void ex_halbtc8192e2ant_halt_notify(struct btc_coexist *btcoexist);
-- 
1.9.1

