Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaBZNQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:16:55 -0500
Received: from sh.osrg.net ([192.16.179.4]:45077 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbaBZNQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:16:52 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 2/2] nilfs2: update project's web site in nilfs2.txt
Date: Wed, 26 Feb 2014 22:12:03 +0900
Message-Id: <1393420323-18255-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1393420323-18255-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1393420323-18255-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20100215(IM150)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (sh.osrg.net [192.16.179.4]); Wed, 26 Feb 2014 22:16:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Project's web site was moved to nilfs.sourceforge.net from
www.nilfs.org.  This updates the site information in
Documentation/filesystems/nilfs2.txt with the new location.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 Documentation/filesystems/nilfs2.txt |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/nilfs2.txt b/Documentation/filesystems/nilfs2.txt
index 8b887ae..41c3d33 100644
--- a/Documentation/filesystems/nilfs2.txt
+++ b/Documentation/filesystems/nilfs2.txt
@@ -25,9 +25,8 @@ available from the following download page.  At least "mkfs.nilfs2",
 cleaner or garbage collector) are required.  Details on the tools are
 described in the man pages included in the package.
 
-Project web page:    http://www.nilfs.org/en/
-Download page:       http://www.nilfs.org/en/download.html
-Git tree web page:   http://www.nilfs.org/git/
+Project web page:    http://nilfs.sourceforge.net/
+Download page:       http://nilfs.sourceforge.net/en/download.html
 List info:           http://vger.kernel.org/vger-lists.html#linux-nilfs
 
 Caveats
-- 
1.7.9.3

