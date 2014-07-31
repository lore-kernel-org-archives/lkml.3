Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaGaSVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 14:21:03 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:54438 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaGaSVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 14:21:00 -0400
From: Rahul Bedarkar <rahulbedarkar89@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Rahul Bedarkar <rahulbedarkar89@gmail.com>
Subject: [PATCH] Documentation: kmemleak: correct spelling mistake
Date: Thu, 31 Jul 2014 23:50:19 +0530
Message-Id: <1406830819-7661-1-git-send-email-rahulbedarkar89@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rahul Bedarkar <rahulbedarkar89@gmail.com>
---
 Documentation/kmemleak.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
index b772418..f4f033c 100644
--- a/Documentation/kmemleak.txt
+++ b/Documentation/kmemleak.txt
@@ -122,7 +122,7 @@ Then as usual to get your report with:
 Freeing kmemleak internal objects
 ---------------------------------
 
-To allow access to previosuly found memory leaks after kmemleak has been
+To allow access to previously found memory leaks after kmemleak has been
 disabled by the user or due to an fatal error, internal kmemleak objects
 won't be freed when kmemleak is disabled, and those objects may occupy
 a large part of physical memory.
-- 
1.8.3.2

