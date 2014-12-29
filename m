Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaL2ObP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:31:15 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:14761 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339AbaL2ObI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:31:08 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQMAHdloVRXQ5FV/2dsb2JhbABcgwaBKrQrAQEBAQEBBQF3lzYCgQsXAQEBAQF9hA0BBVYjEFE5HhmIMAG0Jo8TAQEBByKGA4l0BxaEEwWMPopKkVAig289MYJDAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH 07/11 linux-next] [media] s5p-mfc: remove unnecessary version.h inclusion
Date: Mon, 29 Dec 2014 15:29:41 +0100
Message-Id: <1419863387-24233-8-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419863387-24233-1-git-send-email-fabf@skynet.be>
References: <1419863387-24233-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on versioncheck.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 1 -
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index c6c3452..a9ef843 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -18,7 +18,6 @@
 #include <linux/platform_device.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <linux/workqueue.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index bd64f1d..68df3cd 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -19,7 +19,6 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/sched.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-event.h>
 #include <linux/workqueue.h>
-- 
2.1.0

