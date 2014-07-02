Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbaGBUst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:48:49 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:7622 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363AbaGBUsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:48:47 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AicIANBvtFNXQBPR/2dsb2JhbABagw2sbgEBAQEBAQUBbgGZZwGBBhd1hAQBBVYjEFE5HhmIRgHHZBeFcIhOZAcWhC0FkAWKaJQKg0U7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, sasha.levin@oracle.com, akpm@linux-foundation.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 4/4] fs/cramfs/inode.c: use linux/uaccess.h
Date: Wed,  2 Jul 2014 22:47:15 +0200
Message-Id: <1404334035-7027-5-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1404334035-7027-1-git-send-email-fabf@skynet.be>
References: <1404334035-7027-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes checkpatch warning:

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/cramfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 4d37c35..355c522 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -23,7 +23,7 @@
 #include <linux/vfs.h>
 #include <linux/mutex.h>
 #include <uapi/linux/cramfs_fs.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "internal.h"
 
-- 
1.8.4.5

