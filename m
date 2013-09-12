Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab3ILKLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:11:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38943 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754210Ab3ILKLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:11:17 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: vapier@gentoo.org
Cc: m.chehab@samsung.com, akpm@linux-foundation.org, cesarb@cesarb.net,
        joe@perches.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        realmz6@gmail.com, uclinux-dist-devel@blackfin.uclinux.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] MAINTAINERS: blackfin: add git repository
Date: Thu, 12 Sep 2013 12:10:56 +0200
Message-Id: <1378980656-7208-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the git repository currently in use for
blackfin architecture development.

This information was obtained from Steven Miao.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e61c2e8..288d7d9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1689,6 +1689,7 @@ F:	include/uapi/linux/bfs_fs.h
 BLACKFIN ARCHITECTURE
 M:	Mike Frysinger <vapier@gentoo.org>
 L:	uclinux-dist-devel@blackfin.uclinux.org
+T:	git git://git.code.sf.net/p/adi-linux/code
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	arch/blackfin/
-- 
1.8.1.2

