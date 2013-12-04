Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab3LDX3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:29:37 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:55385 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3LDX3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:29:32 -0500
From: Brian Norris <computersforpeace@gmail.com>
To: <linux-mtd@lists.infradead.org>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] MAINTAINERS: mtd: add Brian Norris for MTD maintenance
Date: Wed,  4 Dec 2013 15:28:45 -0800
Message-Id: <1386199726-28074-2-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1386199726-28074-1-git-send-email-computersforpeace@gmail.com>
References: <1386199726-28074-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While we're at it, change the git URL to remove the version legacy. It's
been a symlink to linux-mtd.git for a while now anyway.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8285ed4676b6..9a7f53bee1cf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5546,10 +5546,11 @@ F:	mm/page_cgroup.c
 
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	David Woodhouse <dwmw2@infradead.org>
+M:	Brian Norris <computersforpeace@gmail.com>
 L:	linux-mtd@lists.infradead.org
 W:	http://www.linux-mtd.infradead.org/
 Q:	http://patchwork.ozlabs.org/project/linux-mtd/list/
-T:	git git://git.infradead.org/mtd-2.6.git
+T:	git git://git.infradead.org/linux-mtd.git
 S:	Maintained
 F:	drivers/mtd/
 F:	include/linux/mtd/
-- 
1.8.5

