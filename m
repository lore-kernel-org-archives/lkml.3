Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaG1Fbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 01:31:40 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:33220 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaG1Fbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 01:31:35 -0400
From: Jessica Yu <jyu@cowsay.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Jessica Yu <jyu@cowsay.org>
Subject: [PATCH v2 1/4] Staging: lustre: linux-module: fix pointer style issue
Date: Mon, 28 Jul 2014 06:33:12 -0700
Message-Id: <1406554395-22779-2-git-send-email-jyu@cowsay.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406554395-22779-1-git-send-email-jyu@cowsay.org>
References: <1406521542-25363-1-git-send-email-jyu@cowsay.org>
 <1406554395-22779-1-git-send-email-jyu@cowsay.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix pointer code style (foo * bar -> foo *bar)

Signed-off-by: Jessica Yu <jyu@cowsay.org>
---
 drivers/staging/lustre/lustre/libcfs/linux/linux-module.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
index ccadf65..b0c00a9 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
@@ -99,7 +99,7 @@ int libcfs_ioctl_popdata(void *arg, void *data, int size)
 extern struct cfs_psdev_ops	  libcfs_psdev_ops;
 
 static int
-libcfs_psdev_open(struct inode * inode, struct file * file)
+libcfs_psdev_open(struct inode *inode, struct file *file)
 {
 	struct libcfs_device_userstate **pdu = NULL;
 	int    rc = 0;
@@ -116,7 +116,7 @@ libcfs_psdev_open(struct inode * inode, struct file * file)
 
 /* called when closing /dev/device */
 static int
-libcfs_psdev_release(struct inode * inode, struct file * file)
+libcfs_psdev_release(struct inode *inode, struct file *file)
 {
 	struct libcfs_device_userstate *pdu;
 	int    rc = 0;
-- 
2.0.1

