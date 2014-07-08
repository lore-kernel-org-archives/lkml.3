Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbaGHTIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:08:06 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:61651 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932333AbaGHTFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:05:55 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgNAORAvFNXQDwH/2dsb2JhbABZgw6tJQEBAQEBAQUBbgGZWQGBFxd1hAQBBSdSEFE5HhmIRgHIJheFeolIBxaELQWadpQMg0U7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 4/9] i40evf: remove unnecessary break after goto
Date: Tue,  8 Jul 2014 21:05:24 +0200
Message-Id: <1404846329-19235-5-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1404846329-19235-1-git-send-email-fabf@skynet.be>
References: <1404846329-19235-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/intel/i40evf/i40evf_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40evf/i40evf_main.c b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
index 7fc5f3b..7195566 100644
--- a/drivers/net/ethernet/intel/i40evf/i40evf_main.c
+++ b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
@@ -2006,7 +2006,6 @@ static void i40evf_init_task(struct work_struct *work)
 		}
 		adapter->state = __I40EVF_INIT_VERSION_CHECK;
 		goto restart;
-		break;
 	case __I40EVF_INIT_VERSION_CHECK:
 		if (!i40evf_asq_done(hw)) {
 			dev_err(&pdev->dev, "Admin queue command never completed\n");
@@ -2028,7 +2027,6 @@ static void i40evf_init_task(struct work_struct *work)
 		}
 		adapter->state = __I40EVF_INIT_GET_RESOURCES;
 		goto restart;
-		break;
 	case __I40EVF_INIT_GET_RESOURCES:
 		/* aq msg sent, awaiting reply */
 		if (!adapter->vf_res) {
-- 
1.8.4.5

