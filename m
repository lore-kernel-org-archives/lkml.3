Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaEAIX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 04:23:26 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:55869 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaEAIXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 04:23:24 -0400
From: Raghavendra Ganiga <ravi23ganiga@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Raghavendra Ganiga <ravi23ganiga@gmail.com>
Subject: [PATCH] staging: comedi: fix coding style issues in comedi_fops.c
Date: Thu,  1 May 2014 13:53:12 +0530
Message-Id: <1398932592-17768-1-git-send-email-ravi23ganiga@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to fix coding style
warnings found by checkpatch.pl tool

Signed-off-by: Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 70545e6..b24bf9b 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -668,6 +668,7 @@ static int do_devconfig_ioctl(struct comedi_device *dev,
 			return -EBUSY;
 		if (dev->attached) {
 			struct module *driver_module = dev->driver->module;
+
 			comedi_device_detach(dev);
 			module_put(driver_module);
 		}
@@ -2653,6 +2654,7 @@ static int __init comedi_init(void)
 	/* create devices files for legacy/manual use */
 	for (i = 0; i < comedi_num_legacy_minors; i++) {
 		struct comedi_device *dev;
+
 		dev = comedi_alloc_board_minor(NULL);
 		if (IS_ERR(dev)) {
 			comedi_cleanup_board_minors();
-- 
1.7.10.4

