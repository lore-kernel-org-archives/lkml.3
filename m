Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaIPE4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 00:56:47 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51142 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbaIPE4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 00:56:46 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: <linux-mtd@lists.infradead.org>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: add l2-mtd.git, 'next' tree for MTD
Date: Mon, 15 Sep 2014 21:56:17 -0700
Message-Id: <1410843377-30159-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've been semi-officially queueing patches here for a while, and it's
in linux-next, so let's advertise it in MAINTAINERS.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 809ecd680d88..55a61f242991 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5898,6 +5898,7 @@ L:	linux-mtd@lists.infradead.org
 W:	http://www.linux-mtd.infradead.org/
 Q:	http://patchwork.ozlabs.org/project/linux-mtd/list/
 T:	git git://git.infradead.org/linux-mtd.git
+T:	git git://git.infradead.org/l2-mtd.git
 S:	Maintained
 F:	drivers/mtd/
 F:	include/linux/mtd/
-- 
1.9.1

