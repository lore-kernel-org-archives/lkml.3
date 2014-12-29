Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaL2OdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:33:16 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:15810 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273AbaL2OdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:33:12 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQMALdloVRXQ5FV/2dsb2JhbABcgwaBKrQrAQEBAQEBBQF3lzYCgQsXAQEBAQF9hA0BBVYjEFE5HhmIMAG0Jo8TAQEBAQYihgOJdAcWhBMFjD6KSoENgmWNXiKDbz0xgkMBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 10/11 linux-next] GenWQE: remove unnecessary version.h inclusion
Date: Mon, 29 Dec 2014 15:32:47 +0100
Message-Id: <1419863567-24329-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419863387-24233-1-git-send-email-fabf@skynet.be>
References: <1419863387-24233-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on versioncheck.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/misc/genwqe/card_base.h  | 1 -
 drivers/misc/genwqe/card_sysfs.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/misc/genwqe/card_base.h b/drivers/misc/genwqe/card_base.h
index c64d7ca..e735344 100644
--- a/drivers/misc/genwqe/card_base.h
+++ b/drivers/misc/genwqe/card_base.h
@@ -34,7 +34,6 @@
 #include <linux/semaphore.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
-#include <linux/version.h>
 #include <linux/debugfs.h>
 #include <linux/slab.h>
 
diff --git a/drivers/misc/genwqe/card_sysfs.c b/drivers/misc/genwqe/card_sysfs.c
index 2c33fbc..6ab31ef 100644
--- a/drivers/misc/genwqe/card_sysfs.c
+++ b/drivers/misc/genwqe/card_sysfs.c
@@ -24,7 +24,6 @@
  * debugging, please also see the debugfs interfaces of this driver.
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/module.h>
-- 
2.1.0

