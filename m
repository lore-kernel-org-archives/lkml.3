Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786AbaJaVsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:48:39 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:18070 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753046AbaJaVsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:48:37 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvgNAKkCVFRXQwLV/2dsb2JhbABcgw6BLLlrBQF0mhoCgRgXAQEBAQF9hAMBBVYjEFE5HhmIRQG8PI5oAQEIIoY3ilkHFoQ1BZ14lkiDeTwvgksBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/8] cdrom: include linux/uaccess.h instead of asm/uaccess.h
Date: Fri, 31 Oct 2014 22:47:57 +0100
Message-Id: <1414792084-7739-2-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414792084-7739-1-git-send-email-fabf@skynet.be>
References: <1414792084-7739-1-git-send-email-fabf@skynet.be>
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
1.9.3

