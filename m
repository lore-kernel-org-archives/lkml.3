Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683AbaISPcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:32:45 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:39019 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591AbaISPck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:32:40 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/3] doc: Document RCU self test boot params
Date: Fri, 19 Sep 2014 11:32:30 -0400
Message-Id: <1411140752-27028-3-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411140752-27028-1-git-send-email-bobby.prani@gmail.com>
References: <1411140752-27028-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the RCU self test boot parameters in kernel-parameters.txt.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 Documentation/kernel-parameters.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c403957..04df74e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3054,6 +3054,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			messages.  Disable with a value less than or equal
 			to zero.
 
+	rcupdate.rcu_self_test= [KNL]
+			Run the RCU early boot self tests
+
+	rcupdate.rcu_self_test_bh= [KNL]
+			Run the RCU bh early boot self tests
+
+	rcupdate.rcu_self_test_sched= [KNL]
+			Run the RCU sched early boot self tests
+
 	rdinit=		[KNL]
 			Format: <full_path>
 			Run specified binary instead of /init from the ramdisk,
-- 
2.1.0

