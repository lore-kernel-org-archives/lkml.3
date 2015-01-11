Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbbAKDQR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 22:16:17 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:61231 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbbAKDQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 22:16:02 -0500
From: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
To: akpm@linux-foundation.org, davem@davemloft.net, joe@perches.com,
        mchehab@osg.samsung.com, crope@iki.fi, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
Subject: [PATCH] MAINTAINERS: add git url entry for UIO
Date: Sat, 10 Jan 2015 19:15:45 -0800
Message-Id: <1420946145-2247-2-git-send-email-mandeep.sandhu@cyaninc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420946145-2247-1-git-send-email-mandeep.sandhu@cyaninc.com>
References: <1420946145-2247-1-git-send-email-mandeep.sandhu@cyaninc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added git url for UIO section.

Signed-off-by: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ddb9ac8..13fa3b7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10146,6 +10146,7 @@ USERSPACE I/O (UIO)
 M:	"Hans J. Koch" <hjk@hansjkoch.de>
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
 F:	Documentation/DocBook/uio-howto.tmpl
 F:	drivers/uio/
 F:	include/linux/uio*.h
-- 
1.9.1

