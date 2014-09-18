Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbaIRDWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 23:22:10 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:52522 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498AbaIRDV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 23:21:58 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH 2/3] doc: Document RCU self test boot params
Date: Wed, 17 Sep 2014 23:21:48 -0400
Message-Id: <1411010509-31927-4-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411010509-31927-1-git-send-email-bobby.prani@gmail.com>
References: <1411010509-31927-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the RCU self test boot parameters in kernel-parameters.txt.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 Documentation/kernel-parameters.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c403957..6f5c01b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3054,6 +3054,18 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
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
+	rcupdate.rcu_self_test_srcu= [KNL]
+			Run the SRCU early boot self tests
+
 	rdinit=		[KNL]
 			Format: <full_path>
 			Run specified binary instead of /init from the ramdisk,
-- 
2.1.0

