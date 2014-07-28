Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaG1Fbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 01:31:51 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:64701 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaG1Fbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 01:31:48 -0400
From: Jessica Yu <jyu@cowsay.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Jessica Yu <jyu@cowsay.org>
Subject: [PATCH v2 3/4] Staging: lustre: linux-module: remove extraneous parens
Date: Mon, 28 Jul 2014 06:33:14 -0700
Message-Id: <1406554395-22779-4-git-send-email-jyu@cowsay.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406554395-22779-1-git-send-email-jyu@cowsay.org>
References: <1406521542-25363-1-git-send-email-jyu@cowsay.org>
 <1406554395-22779-1-git-send-email-jyu@cowsay.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary parens from return statements, return is not a function

Signed-off-by: Jessica Yu <jyu@cowsay.org>
---
 drivers/staging/lustre/lustre/libcfs/linux/linux-module.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
index abd7e6f..745fe4c 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
@@ -154,7 +154,7 @@ static long libcfs_ioctl(struct file *file,
 		if (!capable(CFS_CAP_SYS_BOOT))
 			return (-EPERM);
 		panic("debugctl-invoked panic");
-		return (0);
+		return 0;
 	case IOC_LIBCFS_MEMHOG:
 		if (!capable(CFS_CAP_SYS_ADMIN))
 			return -EPERM;
@@ -167,7 +167,7 @@ static long libcfs_ioctl(struct file *file,
 		rc = libcfs_psdev_ops.p_ioctl(&pfile, cmd, (void *)arg);
 	else
 		rc = -EPERM;
-	return (rc);
+	return rc;
 }
 
 static struct file_operations libcfs_fops = {
-- 
2.0.1

