Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaI0G5I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 02:57:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38314 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751255AbaI0G5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 02:57:06 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, davem@davemloft.net,
        joe@perches.com
Cc: m.chehab@samsung.com, crope@iki.fi, jg1.han@samsung.com,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] MAINTAINERS: orphan m32r
Date: Sat, 27 Sep 2014 08:56:58 +0200
Message-Id: <1411801018-19259-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the maintenance status for m32r

- Removing Hirokazu Takata as maintainer
  (last commit merged: Nov. 2009)

- Remove mailing lists that no longer exist,
  as the ml.linux-m32r.org subdomain no longer exists.

- Maintenance status moved to "Orphan"

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 MAINTAINERS | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 37054306dc9f..cc506173f6ab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5658,11 +5658,8 @@ T:	git git://github.com/linux-test-project/ltp.git
 S:	Maintained
 
 M32R ARCHITECTURE
-M:	Hirokazu Takata <takata@linux-m32r.org>
-L:	linux-m32r@ml.linux-m32r.org (moderated for non-subscribers)
-L:	linux-m32r-ja@ml.linux-m32r.org (in Japanese)
 W:	http://www.linux-m32r.org/
-S:	Maintained
+S:	Orphan
 F:	arch/m32r/
 
 M68K ARCHITECTURE
-- 
1.9.1

