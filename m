Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaCIAr0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 19:47:26 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:43028 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaCIArZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 19:47:25 -0500
From: Nick Davies <git@nicolasdavies.com.au>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nick Davies <git@nicolasdavies.com.au>
Subject: [PATCH] Staging: comedi: comedidev.h Fixed whitespace coding style warnings
Date: Sun,  9 Mar 2014 11:45:51 +1100
Message-Id: <1394325951-10406-1-git-send-email-git@nicolasdavies.com.au>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style warnings in comedidev.h which had an extra space
after the function pointer name.

Signed-off-by: Nick Davies <git@nicolasdavies.com.au>
---
 drivers/staging/comedi/comedidev.h | 48 +++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index f82bd42..6ad4387 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -61,31 +61,31 @@ struct comedi_subdevice {
 
 	unsigned int *chanlist;	/* driver-owned chanlist (not used) */
 
-	int (*insn_read) (struct comedi_device *, struct comedi_subdevice *,
+	int (*insn_read)(struct comedi_device *, struct comedi_subdevice *,
+			 struct comedi_insn *, unsigned int *);
+	int (*insn_write)(struct comedi_device *, struct comedi_subdevice *,
 			  struct comedi_insn *, unsigned int *);
-	int (*insn_write) (struct comedi_device *, struct comedi_subdevice *,
+	int (*insn_bits)(struct comedi_device *, struct comedi_subdevice *,
+			 struct comedi_insn *, unsigned int *);
+	int (*insn_config)(struct comedi_device *, struct comedi_subdevice *,
 			   struct comedi_insn *, unsigned int *);
-	int (*insn_bits) (struct comedi_device *, struct comedi_subdevice *,
-			  struct comedi_insn *, unsigned int *);
-	int (*insn_config) (struct comedi_device *, struct comedi_subdevice *,
-			    struct comedi_insn *, unsigned int *);
-
-	int (*do_cmd) (struct comedi_device *, struct comedi_subdevice *);
-	int (*do_cmdtest) (struct comedi_device *, struct comedi_subdevice *,
-			   struct comedi_cmd *);
-	int (*poll) (struct comedi_device *, struct comedi_subdevice *);
-	int (*cancel) (struct comedi_device *, struct comedi_subdevice *);
+
+	int (*do_cmd)(struct comedi_device *, struct comedi_subdevice *);
+	int (*do_cmdtest)(struct comedi_device *, struct comedi_subdevice *,
+			  struct comedi_cmd *);
+	int (*poll)(struct comedi_device *, struct comedi_subdevice *);
+	int (*cancel)(struct comedi_device *, struct comedi_subdevice *);
 	/* int (*do_lock)(struct comedi_device *, struct comedi_subdevice *); */
 	/* int (*do_unlock)(struct comedi_device *, \
 			struct comedi_subdevice *); */
 
 	/* called when the buffer changes */
-	int (*buf_change) (struct comedi_device *dev,
-			   struct comedi_subdevice *s, unsigned long new_size);
+	int (*buf_change)(struct comedi_device *dev,
+			  struct comedi_subdevice *s, unsigned long new_size);
 
-	void (*munge) (struct comedi_device *dev, struct comedi_subdevice *s,
-		       void *data, unsigned int num_bytes,
-		       unsigned int start_chan_index);
+	void (*munge)(struct comedi_device *dev, struct comedi_subdevice *s,
+		      void *data, unsigned int num_bytes,
+		      unsigned int start_chan_index);
 	enum dma_data_direction async_dma_dir;
 
 	unsigned int state;
@@ -146,8 +146,8 @@ struct comedi_async {
 
 	unsigned int cb_mask;
 
-	int (*inttrig) (struct comedi_device *dev, struct comedi_subdevice *s,
-			unsigned int x);
+	int (*inttrig)(struct comedi_device *dev, struct comedi_subdevice *s,
+		       unsigned int x);
 };
 
 struct comedi_driver {
@@ -155,9 +155,9 @@ struct comedi_driver {
 
 	const char *driver_name;
 	struct module *module;
-	int (*attach) (struct comedi_device *, struct comedi_devconfig *);
-	void (*detach) (struct comedi_device *);
-	int (*auto_attach) (struct comedi_device *, unsigned long);
+	int (*attach)(struct comedi_device *, struct comedi_devconfig *);
+	void (*detach)(struct comedi_device *);
+	int (*auto_attach)(struct comedi_device *, unsigned long);
 
 	/* number of elements in board_name and board_id arrays */
 	unsigned int num_names;
@@ -202,8 +202,8 @@ struct comedi_device {
 
 	struct fasync_struct *async_queue;
 
-	int (*open) (struct comedi_device *dev);
-	void (*close) (struct comedi_device *dev);
+	int (*open)(struct comedi_device *dev);
+	void (*close)(struct comedi_device *dev);
 };
 
 static inline const void *comedi_board(const struct comedi_device *dev)
-- 
1.8.5.3

