Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaI2Qto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:49:44 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:13915 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753821AbaI2Qtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:49:43 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtsSAFmMKVRbtA8r/2dsb2JhbABggw6BKrYYBQFyAZpQBAKBExcBe4RgI4EaN4hCAa9xj2WGEok7AQFPHYQ1BZE9i2uMQIkdg2U7L4EPgTsBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [PATCH 1/1] fat: remove redundant sys_tz declaration
Date: Mon, 29 Sep 2014 18:49:39 +0200
Message-Id: <1412009379-9189-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_tz is already declared extern struct in include/linux/time.h

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/fat/misc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 628e22a..d8da2d2 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -164,8 +164,6 @@ int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster)
 	return 0;
 }
 
-extern struct timezone sys_tz;
-
 /*
  * The epoch of FAT timestamp is 1980.
  *     :  bits :     value
-- 
1.9.3

