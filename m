Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab3LFAZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:25:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:56284 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab3LFAZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:25:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,837,1378882800"; 
   d="scan'208";a="439423998"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: davem@davemloft.net
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, gospo@redhat.com, sassmann@redhat.com
Subject: [net] MAINTAINERS: Update Intel Wired Ethernet LAN Maintainers
Date: Thu,  5 Dec 2013 16:25:20 -0800
Message-Id: <1386289520-15950-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove Tushar and Peter (PJ) as maintainers, since they have moved out
of our group and no longer work on Wired Ethernet.

Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4afcfb4..9641efe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4461,10 +4461,8 @@ M:	Bruce Allan <bruce.w.allan@intel.com>
 M:	Carolyn Wyborny <carolyn.wyborny@intel.com>
 M:	Don Skidmore <donald.c.skidmore@intel.com>
 M:	Greg Rose <gregory.v.rose@intel.com>
-M:	Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
 M:	Alex Duyck <alexander.h.duyck@intel.com>
 M:	John Ronciak <john.ronciak@intel.com>
-M:	Tushar Dave <tushar.n.dave@intel.com>
 L:	e1000-devel@lists.sourceforge.net
 W:	http://www.intel.com/support/feedback.htm
 W:	http://e1000.sourceforge.net/
-- 
1.8.3.1

