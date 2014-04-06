Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaDFL5E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 07:57:04 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45771 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbaDFL5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 07:57:02 -0400
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sergei Trofimovich <slyfox@gentoo.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] cpts: add missing <linux/if_vlan.h>
Date: Sun,  6 Apr 2014 14:55:31 +0300
Message-Id: <1396785331-26875-1-git-send-email-slyich@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>

gcc complains as:
    drivers/net/ethernet/ti/cpts.c: In function 'cpts_match':
    drivers/net/ethernet/ti/cpts.c:266:12: error: 'ETH_HLEN' undeclared (first use in this function)
    drivers/net/ethernet/ti/cpts.c:266:12: note: each undeclared identifier is reported only once for each function it appears in
    drivers/net/ethernet/ti/cpts.c:276:23: error: 'VLAN_HLEN' undeclared (first use in this function)

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
CC: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org
---
 drivers/net/ethernet/ti/cpts.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index a3bbf59..c413e79 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -19,6 +19,7 @@
  */
 #include <linux/err.h>
 #include <linux/if.h>
+#include <linux/if_vlan.h>
 #include <linux/hrtimer.h>
 #include <linux/module.h>
 #include <linux/net_tstamp.h>
-- 
1.9.0

