Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662AbaFIPvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:51:42 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:48437 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaFIPvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:51:39 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: trivial@rustcorp.com.au, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 1/6] update reference, kerneltrap.org no longer works
Date: Mon,  9 Jun 2014 11:51:23 -0400
Message-Id: <1402329088-4802-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kerneltrap.org no longer works, update to a working reference

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 Documentation/RCU/RTFP.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/RCU/RTFP.txt b/Documentation/RCU/RTFP.txt
index 2f0fcb2..f29bcbc 100644
--- a/Documentation/RCU/RTFP.txt
+++ b/Documentation/RCU/RTFP.txt
@@ -2451,8 +2451,8 @@ lot of {Linux} into your technology!!!"
 ,month="February"
 ,year="2010"
 ,note="Available:
-\url{http://kerneltrap.com/mailarchive/linux-netdev/2010/2/26/6270589}
-[Viewed March 20, 2011]"
+\url{http://thread.gmane.org/gmane.linux.network/153338}
+[Viewed June 9, 2014]"
 ,annotation={
 	Use a pair of list_head structures to support RCU-protected
 	resizable hash tables.
-- 
1.9.1

