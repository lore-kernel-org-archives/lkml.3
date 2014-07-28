Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaG1Fbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 01:31:55 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:42802 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaG1Fbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 01:31:51 -0400
From: Jessica Yu <jyu@cowsay.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Jessica Yu <jyu@cowsay.org>
Subject: [PATCH v2 4/4] Staging: lustre: linux-module: add const modifier to file_operations
Date: Mon, 28 Jul 2014 06:33:15 -0700
Message-Id: <1406554395-22779-5-git-send-email-jyu@cowsay.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406554395-22779-1-git-send-email-jyu@cowsay.org>
References: <1406521542-25363-1-git-send-email-jyu@cowsay.org>
 <1406554395-22779-1-git-send-email-jyu@cowsay.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the const modifier to the file_operations struct, since it is
normally const.

Signed-off-by: Jessica Yu <jyu@cowsay.org>
---
 drivers/staging/lustre/lustre/libcfs/linux/linux-module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
index 745fe4c..de3c199 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
@@ -170,7 +170,7 @@ static long libcfs_ioctl(struct file *file,
 	return rc;
 }
 
-static struct file_operations libcfs_fops = {
+static const struct file_operations libcfs_fops = {
 	.unlocked_ioctl	= libcfs_ioctl,
 	.open		= libcfs_psdev_open,
 	.release	= libcfs_psdev_release,
-- 
2.0.1

