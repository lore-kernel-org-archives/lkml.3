Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbaDNB6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 21:58:52 -0400
Received: from smtprelay0077.hostedemail.com ([216.40.44.77]:43339 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754625AbaDNB4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 21:56:41 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1538:1567:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3865:3868:3871:4321:5007:6261:10004:10026:10848:11658:11914:12296:12517:12519:12555:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fan50_574bd0f6b0d5a
X-Filterd-Recvd-Size: 1350
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next 3.16 15/19] key: Convert use of typedef ctl_table to struct ctl_table
Date: Sun, 13 Apr 2014 18:55:47 -0700
Message-Id: <ed9af1ed46a6914531d6c5a82dd1df9e5e215ea9.1397438826.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1397438826.git.joe@perches.com>
References: <cover.1397438826.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/key.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index 80d6774..3ae45f0 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -332,7 +332,7 @@ do {									\
 } while (0)
 
 #ifdef CONFIG_SYSCTL
-extern ctl_table key_sysctls[];
+extern struct ctl_table key_sysctls[];
 #endif
 /*
  * the userspace interface
-- 
1.8.1.2.459.gbcd45b4.dirty

