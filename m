Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaC2RqO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 13:46:14 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:37249 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbaC2RqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 13:46:12 -0400
Message-ID: <533706DF.90406@gmail.com>
Date: Sat, 29 Mar 2014 17:46:07 +0000
From: paulmcquad <paulmcquad@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, hsweeten@visionengravers.com,
        abbotti@mev.co.uk
Subject: [PATCH] Staging: comedi: Line indentation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From df22d80899d343314d212e1750dc6ae2a54fa364 Mon Sep 17 00:00:00 2001
From: Paul McQuade <paulmcquad@gmail.com>
Date: Sat, 29 Mar 2014 17:37:38 +0000
Subject: [PATCH] Staging: comedi: Line indentation

Fix line format in comedidev.h

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/comedi/comedidev.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index f82bd42..588e9e7 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -61,29 +61,29 @@ struct comedi_subdevice {
 
     unsigned int *chanlist;    /* driver-owned chanlist (not used) */
 
-    int (*insn_read) (struct comedi_device *, struct comedi_subdevice *,
+    int (*insn_read)(struct comedi_device *, struct comedi_subdevice *,
               struct comedi_insn *, unsigned int *);
-    int (*insn_write) (struct comedi_device *, struct comedi_subdevice *,
+    int (*insn_write)(struct comedi_device *, struct comedi_subdevice *,
                struct comedi_insn *, unsigned int *);
-    int (*insn_bits) (struct comedi_device *, struct comedi_subdevice *,
+    int (*insn_bits)(struct comedi_device *, struct comedi_subdevice *,
               struct comedi_insn *, unsigned int *);
-    int (*insn_config) (struct comedi_device *, struct comedi_subdevice *,
+    int (*insn_config)(struct comedi_device *, struct comedi_subdevice *,
                 struct comedi_insn *, unsigned int *);
 
-    int (*do_cmd) (struct comedi_device *, struct comedi_subdevice *);
-    int (*do_cmdtest) (struct comedi_device *, struct comedi_subdevice *,
+    int (*do_cmd)(struct comedi_device *, struct comedi_subdevice *);
+    int (*do_cmdtest)(struct comedi_device *, struct comedi_subdevice *,
                struct comedi_cmd *);
-    int (*poll) (struct comedi_device *, struct comedi_subdevice *);
-    int (*cancel) (struct comedi_device *, struct comedi_subdevice *);
+    int (*poll)(struct comedi_device *, struct comedi_subdevice *);
+    int (*cancel)(struct comedi_device *, struct comedi_subdevice *);
     /* int (*do_lock)(struct comedi_device *, struct comedi_subdevice *); */
     /* int (*do_unlock)(struct comedi_device *, \
             struct comedi_subdevice *); */
 
     /* called when the buffer changes */
-    int (*buf_change) (struct comedi_device *dev,
+    int (*buf_change)(struct comedi_device *dev,
                struct comedi_subdevice *s, unsigned long new_size);
 
-    void (*munge) (struct comedi_device *dev, struct comedi_subdevice *s,
+    void (*munge)(struct comedi_device *dev, struct comedi_subdevice *s,
                void *data, unsigned int num_bytes,
                unsigned int start_chan_index);
     enum dma_data_direction async_dma_dir;
@@ -146,7 +146,7 @@ struct comedi_async {
 
     unsigned int cb_mask;
 
-    int (*inttrig) (struct comedi_device *dev, struct comedi_subdevice *s,
+    int (*inttrig)(struct comedi_device *dev, struct comedi_subdevice *s,
             unsigned int x);
 };
 
@@ -155,9 +155,9 @@ struct comedi_driver {
 
     const char *driver_name;
     struct module *module;
-    int (*attach) (struct comedi_device *, struct comedi_devconfig *);
-    void (*detach) (struct comedi_device *);
-    int (*auto_attach) (struct comedi_device *, unsigned long);
+    int (*attach)(struct comedi_device *, struct comedi_devconfig *);
+    void (*detach)(struct comedi_device *);
+    int (*auto_attach)(struct comedi_device *, unsigned long);
 
     /* number of elements in board_name and board_id arrays */
     unsigned int num_names;
@@ -202,8 +202,8 @@ struct comedi_device {
 
     struct fasync_struct *async_queue;
 
-    int (*open) (struct comedi_device *dev);
-    void (*close) (struct comedi_device *dev);
+    int (*open)(struct comedi_device *dev);
+    void (*close)(struct comedi_device *dev);
 };
 
 static inline const void *comedi_board(const struct comedi_device *dev)
-- 
1.8.3.2

