Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbaIVOOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:14:34 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:36704 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbaIVOOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:14:33 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: dann frazier <dannf@hp.com>, Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] rtc-efi: Add missing module alias
Date: Mon, 22 Sep 2014 16:13:45 +0200
Message-Id: <1411395225-11159-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without proper alias kernel module is not loaded for rtc-efi driver

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/rtc/rtc-efi.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index 8225b89..c384fec 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -232,6 +232,7 @@ static struct platform_driver efi_rtc_driver = {
 
 module_platform_driver_probe(efi_rtc_driver, efi_rtc_probe);
 
+MODULE_ALIAS("platform:rtc-efi");
 MODULE_AUTHOR("dann frazier <dannf@hp.com>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("EFI RTC driver");
-- 
1.7.9.5

