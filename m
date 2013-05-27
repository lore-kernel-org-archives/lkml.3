Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab3E0OcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 10:32:22 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:52359 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758054Ab3E0OcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 10:32:21 -0400
MIME-Version: 1.0
Date: Mon, 27 May 2013 15:32:19 +0100
Message-ID: <CAMGf+V48=xZjkiJ2siYD+5bDFt7yqWU2NNggo8cEKCrpJEJqgQ@mail.gmail.com>
Subject: [PATCH] vfs: Trivial libfs.c warning formatting
From: Colin Fowler <elethiomel@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Fowler <elethiomel@gmail.com>
Kernel Version: 3.10-rc3.
Description: Add a space between "array" and "with" in
simple_fill_super() warning message

Signed-off-by: Colin Fowler <elethiomel@gmail.com>
---
--- linux-3.10-rc3/fs/libfs.c.orig	2013-05-27 14:48:36.741568310 +0100
+++ linux-3.10-rc3/fs/libfs.c	2013-05-27 14:49:05.675027823 +0100
@@ -505,7 +505,7 @@ int simple_fill_super(struct super_block

 		/* warn if it tries to conflict with the root inode */
 		if (unlikely(i == 1))
-			printk(KERN_WARNING "%s: %s passed in a files array"
+			printk(KERN_WARNING "%s: %s passed in a files array "
 				"with an index of 1!\n", __func__,
 				s->s_type->name);
