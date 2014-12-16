Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751074AbaLPRsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 12:48:19 -0500
Received: from mga03.intel.com ([134.134.136.65]:29137 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaLPRsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 12:48:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,587,1413270000"; 
   d="scan'208";a="655009747"
Date: Wed, 17 Dec 2014 01:33:16 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Jon Medhurst <tixy@linaro.org>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org
Subject: [PATCH tixy] gator: wq_get_stats can be static
Message-ID: <20141216173316.GA63428@snb.sh.intel.com>
References: <201412170151.C4iMWfhE%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201412170151.C4iMWfhE%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/gator/gator_events_net.c:48:1: sparse: symbol 'wq_get_stats' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 gator_events_net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gator/gator_events_net.c b/drivers/gator/gator_events_net.c
index d21b4db..47fee71 100644
--- a/drivers/gator/gator_events_net.c
+++ b/drivers/gator/gator_events_net.c
@@ -45,7 +45,7 @@ static void get_network_stats(struct work_struct *wsptr)
 	tx_total = tx;
 }
 
-DECLARE_WORK(wq_get_stats, get_network_stats);
+static DECLARE_WORK(wq_get_stats, get_network_stats);
 
 static void net_wake_up_handler(unsigned long unused_data)
 {
