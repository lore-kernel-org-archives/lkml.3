Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbbAJCN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:13:59 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:55500 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbbAJCNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:13:50 -0500
From: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
To: akpm@linux-foundation.org, davem@davemloft.net, joe@perches.com,
        mchehab@osg.samsung.com, crope@iki.fi, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
Subject: [PATCH] MAINTAINERS: add git url entry for UIO
Date: Fri,  9 Jan 2015 18:13:31 -0800
Message-Id: <1420856011-1491-2-git-send-email-mandeep.sandhu@cyaninc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420856011-1491-1-git-send-email-mandeep.sandhu@cyaninc.com>
References: <1420856011-1491-1-git-send-email-mandeep.sandhu@cyaninc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added git url for UIO section.

Signed-off-by: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ddb9ac8..9334680 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10149,6 +10149,7 @@ S:	Maintained
 F:	Documentation/DocBook/uio-howto.tmpl
 F:	drivers/uio/
 F:	include/linux/uio*.h
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
 
 UTIL-LINUX PACKAGE
 M:	Karel Zak <kzak@redhat.com>
-- 
1.9.1

