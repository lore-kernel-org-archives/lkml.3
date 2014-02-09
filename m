Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaBIO3R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 09:29:17 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:49641 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaBIO3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 09:29:16 -0500
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        josh@joshtriplett.org
Subject: =?UTF-8?q?=5BPATCH=20v2=2002/13=5D=20net=3A=20Include=20appropriate=20header=20file=20in=20caif/caif=5Fdev=2Ec?=
Date: Sun,  9 Feb 2014 19:59:04 +0530
Message-Id: <30885a464918e0f7cbb55b5c521a048f3e369c27.1391955924.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <6f029c895035908595957fb16ab445c82793c77d.1391955924.git.rashika.kheria@gmail.com>
References: <6f029c895035908595957fb16ab445c82793c77d.1391955924.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file net/caif/caif_dev.h in caif/caif_dev.c
because it has prototype declarations of function defined in
caif/caif_dev.c.

This eliminates the following file in caif/caif_dev.c:
net/caif/caif_dev.c:303:6: warning: no previous prototype for ‘caif_enroll_dev’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
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

