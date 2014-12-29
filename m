Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaL2Ocm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:32:42 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:25326 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752357AbaL2ObL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:31:11 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am0QAHdloVRXQ5FV/2dsb2JhbABcgwaBKrQrAQEBAQEBBQF3lzAEAgKBCxcBAQEBAX2EDQEFViMQUTkeGYgwAbQmjxMBAQEHIoYDiRBkBxaEEwWMPopKkVAig289MYEDgUABAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH 06/11 linux-next] [media] s5p-g2d: remove unnecessary version.h inclusion
Date: Mon, 29 Dec 2014 15:29:40 +0100
Message-Id: <1419863387-24233-7-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419863387-24233-1-git-send-email-fabf@skynet.be>
References: <1419863387-24233-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on versioncheck.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/platform/s5p-g2d/g2d.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 47ba8fb..ec3e124 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -12,7 +12,6 @@
 
 #include <linux/module.h>
 #include <linux/fs.h>
-#include <linux/version.h>
 #include <linux/timer.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-- 
2.1.0

