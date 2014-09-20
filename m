Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaITK4T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 06:56:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23694 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaITK4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 06:56:18 -0400
From: Ethan Zhao <ethan.zhao@oracle.com>
To: jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, carolyn.wyborny@intel.com,
        donald.c.skidmore@intel.com, gregory.v.rose@intel.com,
        alexander.h.duyck@intel.com, john.ronciak@intel.com,
        mitch.a.williams@intel.com
Cc: linux.nics@intel.co, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ethan Zhao <ethan.zhao@oracle.com>
Subject: [PATCH] ixgbe: delete one duplicate marcro definition of IXGBE_MAX_L2A_QUEUES
Date: Sat, 20 Sep 2014 18:53:27 +0800
Message-Id: <1411210407-3185-1-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is typo in ixgbe.h, two marcro definition of IXGBE_MAX_L2A_QUEUES to 4,
delete one, clear the compiler warning.

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index ac9f214..bfb2c23 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -307,7 +307,6 @@ enum ixgbe_ring_f_enum {
 #define MAX_RX_QUEUES (IXGBE_MAX_FDIR_INDICES + 1)
 #define MAX_TX_QUEUES (IXGBE_MAX_FDIR_INDICES + 1)
 #define IXGBE_MAX_L2A_QUEUES 4
-#define IXGBE_MAX_L2A_QUEUES 4
 #define IXGBE_BAD_L2A_QUEUE 3
 #define IXGBE_MAX_MACVLANS	31
 #define IXGBE_MAX_DCBMACVLANS	8
-- 
1.7.1

