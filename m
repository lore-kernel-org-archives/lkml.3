Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbbAAKkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 05:40:20 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:54914 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbbAAKkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 05:40:14 -0500
From: Richard Cochran <richardcochran@gmail.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH net-next 5/7] ixgbe: convert to CYCLECOUNTER_MASK macro.
Date: Thu,  1 Jan 2015 11:39:59 +0100
Message-Id: <22de72fbea439dfa93bcfd835b56e3e5f756a055.1420108214.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20141231.183347.862533634176009078.davem@davemloft.net>
References: <20141231.183347.862533634176009078.davem@davemloft.net>
In-Reply-To: <cover.1420108214.git.richardcochran@gmail.com>
References: <cover.1420108214.git.richardcochran@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
index 47c29ea..79c00f5 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
@@ -793,7 +793,7 @@ void ixgbe_ptp_start_cyclecounter(struct ixgbe_adapter *adapter)
 
 	memset(&adapter->cc, 0, sizeof(adapter->cc));
 	adapter->cc.read = ixgbe_ptp_read;
-	adapter->cc.mask = CLOCKSOURCE_MASK(64);
+	adapter->cc.mask = CYCLECOUNTER_MASK(64);
 	adapter->cc.shift = shift;
 	adapter->cc.mult = 1;
 
-- 
1.7.10.4

