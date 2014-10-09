Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbaJIQj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:39:58 -0400
Received: from mx02.posteo.de ([89.146.194.165]:56433 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755824AbaJIQjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:39:49 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] char: documentation: more useful information about misc device
Date: Thu,  9 Oct 2014 18:37:35 +0200
Message-Id: <1412872655-11403-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20141009155020.GB27912@kroah.com>
References: <20141009155020.GB27912@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This might prevent code duplication in the future.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
This is a suggestion for a place to put this information. I think this
makes sense but there might be a more appropriate place elsewhere.

 drivers/char/misc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index ffa97d2..6a3d15b 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -171,6 +171,10 @@ static const struct file_operations misc_fops = {
  *	The structure passed is linked into the kernel and may not be
  *	destroyed until it has been unregistered.
  *
+ *	If struct miscdevice's fops contain an implementation of open()
+ *	the struct file's private data will be a pointer back to
+ *	struct miscdevice.
+ *
  *	A zero is returned on success and a negative errno code for
  *	failure.
  */
-- 
1.7.10.4

