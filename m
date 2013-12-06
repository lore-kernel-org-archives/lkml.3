Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab3LFJFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:05:38 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:65450 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab3LFJF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:05:27 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org
Cc: minchan@kernel.org, pyrasis@gamil.com, harryxiyou@gmail.com,
        tshibata@ab.jp.nec.com, rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 1/4] Documentation: HOWTO: Update broken links to tpp
Date: Fri,  6 Dec 2013 18:04:42 +0900
Message-Id: <1386320685-28484-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sites for 'The Perfect Patch' which described on HOWTO
document(kerneltrap.org and userweb.kernel.org) are down.
Change those links to the copy at ozlabs.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 Documentation/HOWTO | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 27faae3..57cf5ef 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -112,7 +112,7 @@ required reading:
 
     Other excellent descriptions of how to create patches properly are:
 	"The Perfect Patch"
-		http://kerneltrap.org/node/3737
+		http://www.ozlabs.org/~akpm/stuff/tpp.txt
 	"Linux kernel patch submission format"
 		http://linux.yyz.us/patch-format.html
 
@@ -579,7 +579,7 @@ all time.  It should describe the patch completely, containing:
 For more details on what this should all look like, please see the
 ChangeLog section of the document:
   "The Perfect Patch"
-      http://userweb.kernel.org/~akpm/stuff/tpp.txt
+      http://www.ozlabs.org/~akpm/stuff/tpp.txt
 
 
 
-- 
1.8.1.2

