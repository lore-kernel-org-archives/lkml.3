Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaLGJOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 04:14:33 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36694 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaLGJOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 04:14:30 -0500
From: Athira Lekshmi <andnlnbn18@gmail.com>
To: rogerable@realtek.com
Cc: linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        Athira Lekshmi <andnlnbn18@gmail.com>
Subject: [PATCH v2] Drivers: memstick: host: Fixed missing a blank line warning
Date: Sun,  7 Dec 2014 14:44:29 +0530
Message-Id: <1417943669-4057-1-git-send-email-andnlnbn18@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a new line after declaration to fix the warning message
'Missing a blank line after declarations'

Signed-off-by: Athira Lekshmi <andnlnbn18@gmail.com>
---
 drivers/memstick/host/rtsx_usb_ms.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/memstick/host/rtsx_usb_ms.c b/drivers/memstick/host/rtsx_usb_ms.c
index a7282b7..cefd745 100644
--- a/drivers/memstick/host/rtsx_usb_ms.c
+++ b/drivers/memstick/host/rtsx_usb_ms.c
@@ -59,6 +59,7 @@ static inline struct device *ms_dev(struct rtsx_usb_ms *host)
 static inline void ms_clear_error(struct rtsx_usb_ms *host)
 {
 	struct rtsx_ucr *ucr = host->ucr;
+
 	rtsx_usb_ep0_write_register(ucr, CARD_STOP,
 				  MS_STOP | MS_CLR_ERR,
 				  MS_STOP | MS_CLR_ERR);
-- 
1.7.9.5

