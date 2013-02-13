Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970Ab3BMSyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:54:47 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:42972 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab3BMSyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:54:46 -0500
From: Maksim Pikhenko <pikhenko@gmail.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, Maksim Pikhenko <pikhenko@gmail.com>
Subject: [PATCH] :fs :fat Delete unnecessary blank line.
Date: Wed, 13 Feb 2013 22:53:47 +0400
Message-Id: <1360781627-9710-1-git-send-email-pikhenko@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing a code style issue.

Signed-off-by: Maksim Pikhenko <pikhenko@gmail.com>
---
 fs/fat/inode.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index f8f4916..1af574b 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1476,7 +1476,6 @@ out_fail:
 	kfree(sbi);
 	return error;
 }
-
 EXPORT_SYMBOL_GPL(fat_fill_super);
 
 /*
-- 
1.7.10.4

