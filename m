Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaBCQzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:55:10 -0500
Received: from sh.osrg.net ([192.16.179.4]:59543 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbaBCQzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:55:05 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-nilfs <linux-nilfs@vger.kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 1/4] nilfs2: update MAINTAINERS file entries
Date: Tue,  4 Feb 2014 01:50:41 +0900
Message-Id: <1391446244-1435-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1391446244-1435-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1391446244-1435-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20100215(IM150)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (sh.osrg.net [192.16.179.4]); Tue, 04 Feb 2014 01:55:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update git repository entry of nilfs2 file system and maintainer's
email description.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b2cf5cf..342caaa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6085,10 +6085,10 @@ F:	include/uapi/linux/nfs*
 F:	include/uapi/linux/sunrpc/
 
 NILFS2 FILESYSTEM
-M:	KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
+M:	Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
 L:	linux-nilfs@vger.kernel.org
 W:	http://www.nilfs.org/en/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git
+T:	git git://github.com/konis/nilfs2.git
 S:	Supported
 F:	Documentation/filesystems/nilfs2.txt
 F:	fs/nilfs2/
-- 
1.7.9.3

