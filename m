Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaATITw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:19:52 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:51092 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaATITt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:19:49 -0500
From: Surendra Patil <surendra.tux@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Surendra Patil <surendra.tux@gmail.com>
Subject: [PATCH] Staging : comedi : comedidev.h Fixed warning space coding style issue
Date: Mon, 20 Jan 2014 00:19:09 -0800
Message-Id: <1390205949-12102-1-git-send-email-surendra.tux@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue,removed space after the function pointer name

Signed-off-by: Surendra Patil <surendra.tux@gmail.com>
---
 drivers/staging/comedi/comedidev.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index f82bd42..588e9e7 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -61,29 +61,29 @@ struct comedi_subdevice {
 
 	unsigned int *chanlist;	/* driver-owned chanlist (not used) */
 
-	int (*insn_read) (struct comedi_device *, struct comedi_subdevice *,
+	int (*insn_read)(struct comedi_device *, struct comedi_subdevice *,
 			  struct comedi_insn *, unsigned int *);
-	int (*insn_write) (struct comedi_device *, struct comedi_subdevice *,
+	int (*insn_write)(struct comedi_device *, struct comedi_subdevice *,
 			   struct comedi_insn *, unsigned int *);
-	int (*insn_bits) (struct comedi_device *, struct comedi_subdevice *,
+	int (*insn_bits)(struct comedi_device *, struct comedi_subdevice *,
 			  struct comedi_insn *, unsigned int *);
-	int (*insn_config) (struct comedi_device *, struct comedi_subdevice *,
+	int (*insn_config)(struct comedi_device *, struct comedi_subdevice *,
 			    struct comedi_insn *, unsigned int *);
 
-	int (*do_cmd) (struct comedi_device *, struct comedi_subdevice *);
-	int (*do_cmdtest) (struct comedi_device *, struct comedi_subdevice *,
+	int (*do_cmd)(struct comedi_device *, struct comedi_subdevice *);
+	int (*do_cmdtest)(struct comedi_device *, struct comedi_subdevice *,
 			   struct comedi_cmd *);
-	int (*poll) (struct comedi_device *, struct comedi_subdevice *);
-	int (*cancel) (struct comedi_device *, struct comedi_subdevice *);
+	int (*poll)(struct comedi_device *, struct comedi_subdevice *);
+	int (*cancel)(struct comedi_device *, struct comedi_subdevice *);
 	/* int (*do_lock)(struct comedi_device *, struct comedi_subdevice *); */
 	/* int (*do_unlock)(struct comedi_device *, \
 			struct comedi_subdevice *); */
 
 	/* called when the buffer changes */
-	int (*buf_change) (struct comedi_device *dev,
+	int (*buf_change)(struct comedi_device *dev,
 			   struct comedi_subdevice *s, unsigned long new_size);
 
-	void (*munge) (struct comedi_device *dev, struct comedi_subdevice *s,
+	void (*munge)(struct comedi_device *dev, struct comedi_subdevice *s,
 		       void *data, unsigned int num_bytes,
 		       unsigned int start_chan_index);
 	enum dma_data_direction async_dma_dir;
@@ -146,7 +146,7 @@ struct comedi_async {
 
 	unsigned int cb_mask;
 
-	int (*inttrig) (struct comedi_device *dev, struct comedi_subdevice *s,
+	int (*inttrig)(struct comedi_device *dev, struct comedi_subdevice *s,
 			unsigned int x);
 };
 
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
1.8.3.2

