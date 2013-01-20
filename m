Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab3ATXNW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 18:13:22 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:59654 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab3ATXNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 18:13:19 -0500
From: Patrik Karlin <patrik.karlin@gmail.com>
To: chas@cmf.nrl.navy.mil
Cc: linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Patrik Karlin <patrik.karlin@gmail.com>
Subject: [PATCH 2/5] drivers: atm: checkpatch.pl fixes removed all trailing whitespaces in eni.c
Date: Mon, 21 Jan 2013 00:12:52 +0100
Message-Id: <1358723575-8345-2-git-send-email-patrik.karlin@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358723575-8345-1-git-send-email-patrik.karlin@gmail.com>
References: <1358723575-8345-1-git-send-email-patrik.karlin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes all trailing whitespace's in eni.c
as sugested by checkpatch.pl

Signed-off-by: Patrik Kårlin <patrik.karlin@gmail.com>
---
 drivers/atm/eni.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 6ae0d89..1d5adc2 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -1,7 +1,7 @@
 /* drivers/atm/eni.c - Efficient Networks ENI155P device driver */
- 
+
 /* Written 1995-2000 by Werner Almesberger, EPFL LRC/ICA */
- 
+
 
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -33,7 +33,7 @@
 #if !defined(__i386__) && !defined(__x86_64__)
 #ifndef ioremap_nocache
 #define ioremap_nocache(X, Y) ioremap(X, Y)
-#endif 
+#endif
 #endif
 
 /*
@@ -90,7 +90,7 @@ static void event_dump(void)
 #else
 
 
-/* 
+/*
  * NULL pointer checking
  */
 
@@ -112,7 +112,7 @@ static int ec = 0;
 
 static void EVENT(const char *s, unsigned long a, unsigned long b)
 {
-	ev[ec] = s; 
+	ev[ec] = s;
 	ev_a[ec] = a;
 	ev_b[ec] = b;
 	ec = (ec+1) % EV;
@@ -1800,7 +1800,7 @@ static void eni_do_release(struct atm_dev *dev)
 static int eni_start(struct atm_dev *dev)
 {
 	struct eni_dev *eni_dev;
-	
+
 	void __iomem *buf;
 	unsigned long buffer_mem;
 	int error;
@@ -2148,7 +2148,7 @@ static int eni_proc_read(struct atm_dev *dev, loff_t *pos, char *page)
 		    " (default)"
 #endif
 		    "\n", "");
-	if (!--left) 
+	if (!--left)
 		return sprintf(page, "%4sBuffer multipliers: tx %d%%, rx %d%%\n",
 		    "", eni_dev->tx_mult, eni_dev->rx_mult);
 	for (i = 0; i < NR_CHAN; i++) {
-- 
1.7.10.4

