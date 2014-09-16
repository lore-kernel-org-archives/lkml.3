Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbaIPSEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:04:36 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:57605 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013AbaIPSEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:04:35 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkMOAF97GFRXQAMM/2dsb2JhbABggw2BKrQQBQFvmxiBFBcBeYRgI4EaN4hCAbw3hXyIa2QdhDUFnQqVRYFpHIFbOy+BBoFEAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: tgraf@suug.ch, davem@davemloft.net, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1] lib: rhashtable: remove second linux/log2.h inclusion
Date: Tue, 16 Sep 2014 20:04:18 +0200
Message-Id: <1410890658-31144-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/log2.h was included twice.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 lib/rhashtable.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index a2c7881..7b36e4d 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -23,7 +23,6 @@
 #include <linux/hash.h>
 #include <linux/random.h>
 #include <linux/rhashtable.h>
-#include <linux/log2.h>
 
 #define HASH_DEFAULT_SIZE	64UL
 #define HASH_MIN_SIZE		4UL
-- 
2.1.0

