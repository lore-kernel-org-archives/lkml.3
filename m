Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbaDLNUX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 09:20:23 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:59513 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaDLNT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 09:19:27 -0400
From: Dominique van den Broeck <domdevlin@free.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dominique van den Broeck <domdevlin@free.fr>
Subject: [PATCH v2 3/4] fwserial: (coding style) useless "extern" & space
Date: Sat, 12 Apr 2014 15:18:14 +0200
Message-Id: <1397308695-30779-3-git-send-email-domdevlin@free.fr>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397308695-30779-1-git-send-email-domdevlin@free.fr>
References: <20140412010411.GA29370@kroah.com>
 <1397308695-30779-1-git-send-email-domdevlin@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Style-only modifications to make checkpatch.pl --file --strict a bit happier.
Removed useless "extern" in dma_fifo.h ;
Removed one supernumerary space.

Signed-off-by: Dominique van den Broeck <domdevlin@free.fr>
---
diff -upr a/drivers/staging/fwserial/dma_fifo.h b/drivers/staging/fwserial/dma_fifo.h
--- a/drivers/staging/fwserial/dma_fifo.h	2014-04-11 20:48:20.813667706 +0200
+++ b/drivers/staging/fwserial/dma_fifo.h	2014-04-11 20:47:49.700058306 +0200
@@ -85,15 +81,15 @@ static inline bool dp_is_completed(struc
 	return (unsigned long)dp->data & 1UL;
 }
 
-extern void dma_fifo_init(struct dma_fifo *fifo);
-extern int dma_fifo_alloc(struct dma_fifo *fifo, int size, unsigned align,
-			  int tx_limit, int open_limit, gfp_t gfp_mask);
-extern void dma_fifo_free(struct dma_fifo *fifo);
-extern void dma_fifo_reset(struct dma_fifo *fifo);
-extern int dma_fifo_in(struct dma_fifo *fifo, const void *src, int n);
-extern int dma_fifo_out_pend(struct dma_fifo *fifo, struct dma_pending *pended);
-extern int dma_fifo_out_complete(struct dma_fifo *fifo,
-				 struct dma_pending *complete);
+void dma_fifo_init(struct dma_fifo *fifo);
+int dma_fifo_alloc(struct dma_fifo *fifo, int size, unsigned align,
+		   int tx_limit, int open_limit, gfp_t gfp_mask);
+void dma_fifo_free(struct dma_fifo *fifo);
+void dma_fifo_reset(struct dma_fifo *fifo);
+int dma_fifo_in(struct dma_fifo *fifo, const void *src, int n);
+int dma_fifo_out_pend(struct dma_fifo *fifo, struct dma_pending *pended);
+int dma_fifo_out_complete(struct dma_fifo *fifo,
+			  struct dma_pending *complete);
 
 /* returns the # of used bytes in the fifo */
 static inline int dma_fifo_level(struct dma_fifo *fifo)
diff -upr a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
--- a/drivers/staging/fwserial/fwserial.c	2014-04-11 20:48:20.813667706 +0200
+++ b/drivers/staging/fwserial/fwserial.c	2014-04-11 20:47:49.701058326 +0200
@@ -1820,7 +1818,7 @@ static void fwserial_release_port(struct
 
 static void fwserial_plug_timeout(unsigned long data)
 {
-	struct fwtty_peer *peer = (struct fwtty_peer *) data;
+	struct fwtty_peer *peer = (struct fwtty_peer *)data;
 	struct fwtty_port *port;
 
 	spin_lock_bh(&peer->lock);
