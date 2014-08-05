Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaHEXaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:30:20 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:39320 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaHEXaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:30:19 -0400
From: Dzonatans Melgalvis <dz.melgalvis@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dzonatans Melgalvis <dz.melgalvis@gmail.com>
Subject: [PATCH] Staging: comedi: comedidev.h: fix checkpatch code style issue
Date: Wed,  6 Aug 2014 02:29:45 +0300
Message-Id: <1407281385-12576-1-git-send-email-dz.melgalvis@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing checkpatch warning - blank line missing after declaration.

Signed-off-by: Dzonatans Melgalvis <dz.melgalvis@gmail.com>
---
 drivers/staging/comedi/comedidev.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 58e58a3..c9b7978 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -57,6 +57,7 @@ struct comedi_subdevice {
 	const unsigned int *maxdata_list;	/* list is channel specific */
 
 	const struct comedi_lrange *range_table;
+
 	const struct comedi_lrange *const *range_table_list;
 
 	unsigned int *chanlist;	/* driver-owned chanlist (not used) */
@@ -207,8 +208,10 @@ struct comedi_async {
 	struct comedi_cmd cmd;
 	wait_queue_head_t wait_head;
 	unsigned int cb_mask;
+
 	int (*inttrig)(struct comedi_device *dev, struct comedi_subdevice *s,
 		       unsigned int x);
+
 };
 
 struct comedi_driver {
@@ -216,13 +219,16 @@ struct comedi_driver {
 
 	const char *driver_name;
 	struct module *module;
+
 	int (*attach)(struct comedi_device *, struct comedi_devconfig *);
 	void (*detach)(struct comedi_device *);
 	int (*auto_attach)(struct comedi_device *, unsigned long);
 
 	/* number of elements in board_name and board_id arrays */
 	unsigned int num_names;
+
 	const char *const *board_name;
+
 	/* offset in bytes from one board name pointer to the next */
 	int offset;
 };
-- 
1.9.1

