Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab3IMO5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:57:39 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:44719 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab3IMO5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:57:38 -0400
Date: Fri, 13 Sep 2013 22:57:18 +0800
From: ZHAO Gang <gamerh2o@gmail.com>
To: gamerh2o@gmail.com
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [Trivial] remove unnecessary header file inclusion
Message-ID: <20130913145718.GA2536@will>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


file linux/fib_rules.h doesn't exist, so remove it.

Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
---
 include/net/fib_rules.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/fib_rules.h b/include/net/fib_rules.h
index 4b2b557..c816f91 100644
--- a/include/net/fib_rules.h
+++ b/include/net/fib_rules.h
@@ -4,7 +4,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/netdevice.h>
-#include <linux/fib_rules.h>
 #include <net/flow.h>
 #include <net/rtnetlink.h>
 
-- 
1.8.3.1

