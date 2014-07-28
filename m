Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaG1Fbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 01:31:46 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:64944 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaG1Fbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 01:31:42 -0400
From: Jessica Yu <jyu@cowsay.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Jessica Yu <jyu@cowsay.org>
Subject: [PATCH v2 2/4] Staging: lustre: linux-module: remove unnecessary spaces
Date: Mon, 28 Jul 2014 06:33:13 -0700
Message-Id: <1406554395-22779-3-git-send-email-jyu@cowsay.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406554395-22779-1-git-send-email-jyu@cowsay.org>
References: <1406521542-25363-1-git-send-email-jyu@cowsay.org>
 <1406554395-22779-1-git-send-email-jyu@cowsay.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove extraneous space after open paren and before close paren.

Signed-off-by: Jessica Yu <jyu@cowsay.org>
---
 drivers/staging/lustre/lustre/libcfs/linux/linux-module.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
index b0c00a9..abd7e6f 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
@@ -140,9 +140,9 @@ static long libcfs_ioctl(struct file *file,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if ( _IOC_TYPE(cmd) != IOC_LIBCFS_TYPE ||
+	if (_IOC_TYPE(cmd) != IOC_LIBCFS_TYPE ||
 	     _IOC_NR(cmd) < IOC_LIBCFS_MIN_NR  ||
-	     _IOC_NR(cmd) > IOC_LIBCFS_MAX_NR ) {
+	     _IOC_NR(cmd) > IOC_LIBCFS_MAX_NR) {
 		CDEBUG(D_IOCTL, "invalid ioctl ( type %d, nr %d, size %d )\n",
 		       _IOC_TYPE(cmd), _IOC_NR(cmd), _IOC_SIZE(cmd));
 		return (-EINVAL);
-- 
2.0.1

