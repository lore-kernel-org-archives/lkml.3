Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbaKJUWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:22:34 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:26770 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752156AbaKJUWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:22:11 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMSAMAdYVRXQ4qy/2dsb2JhbABcgw6BLbgoBQF0miYEAgKBJxcBAQEBAX2EAwEFViMQUTkeGYhFAb0cj38BAQgihjqKWwcWhDUFniWWYII2gUU8L4JLAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Jens Axboe <axboe@kernel.dk>,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH v2 01/10 linux-next] cdrom: include linux/uaccess.h instead of asm/uaccess.h
Date: Mon, 10 Nov 2014 21:21:46 +0100
Message-Id: <1415650916-9975-2-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415650916-9975-1-git-send-email-fabf@skynet.be>
References: <1415650916-9975-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/cdrom/cdrom.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 5d28a45..c7fa0e2 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -281,8 +281,7 @@
 #include <linux/fcntl.h>
 #include <linux/blkdev.h>
 #include <linux/times.h>
-
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 /* used to tell the module to turn on full debugging messages */
 static bool debug;
-- 
1.9.1

