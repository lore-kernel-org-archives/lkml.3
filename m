Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbaKHQjJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 11:39:09 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56836 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaKHQjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 11:39:08 -0500
Message-ID: <1415464746.12634.10.camel@mail.huji.ac.il>
Subject: PATCH: Fix coding style warning.
From: sharon <sharon.dvir1@mail.huji.ac.il>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sat, 08 Nov 2014 18:39:06 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style warning.
(First submission, sorry in advance for any dumb stuff I'm missing.
Let me know and I'll fix it.)

Signed-off-by: Sharon Dvir <sharon.dvir1@mail.huji.ac.il>

diff --git a/drivers/staging/android/binder.c
b/drivers/staging/android/binder.c
index c69c40d..655c3bf 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -1267,8 +1267,8 @@ static void
binder_transaction_buffer_release(struct binder_proc *proc,
 		switch (fp->type) {
 		case BINDER_TYPE_BINDER:
 		case BINDER_TYPE_WEAK_BINDER: {
-			struct binder_node *node = binder_get_node(proc, fp->binder);
-
+			struct binder_node *node = binder_get_node(proc,
+								fp->binder);
 			if (node == NULL) {
 				pr_err("transaction release %d bad node %016llx\n",
 				       debug_id, (u64)fp->binder);

