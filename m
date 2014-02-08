Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaBHTtu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 14:49:50 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58724 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaBHTts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 14:49:48 -0500
Date: Sun, 9 Feb 2014 01:19:43 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 02/13] net: Include appropriate header file in caif/caif_dev.c
Message-ID: <30885a464918e0f7cbb55b5c521a048f3e369c27.1391888654.git.rashika.kheria@gmail.com>
References: <6f029c895035908595957fb16ab445c82793c77d.1391888654.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6f029c895035908595957fb16ab445c82793c77d.1391888654.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file net/caif/caif_dev.h in caif/caif_dev.c
because it has prototype declarations of function defined in
caif/caif_dev.c.

This eliminates the following file in caif/caif_dev.c:
net/caif/caif_dev.c:303:6: warning: no previous prototype for ‘caif_enroll_dev’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 net/caif/caif_dev.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/caif/caif_dev.c b/net/caif/caif_dev.c
index 4dca159..edbca46 100644
--- a/net/caif/caif_dev.c
+++ b/net/caif/caif_dev.c
@@ -22,6 +22,7 @@
 #include <net/pkt_sched.h>
 #include <net/caif/caif_device.h>
 #include <net/caif/caif_layer.h>
+#include <net/caif/caif_dev.h>
 #include <net/caif/cfpkt.h>
 #include <net/caif/cfcnfg.h>
 #include <net/caif/cfserl.h>
-- 
1.7.9.5

