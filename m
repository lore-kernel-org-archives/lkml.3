Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab3JGWo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 18:44:57 -0400
Received: from smtprelay0106.hostedemail.com ([216.40.44.106]:45073 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751197Ab3JGWoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 18:44:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3867:4321:5007:6642:7652:8957:10004:10400:10848:11026:11473:11657:11658:11914:12043:12048:12438:12517:12519:12555:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: water16_81da48343c20c
X-Filterd-Recvd-Size: 2288
Message-ID: <1381185890.2081.223.camel@joe-AO722>
Subject: [PATCH] iscsi_iser: Add missing newlines to logging messages
From: Joe Perches <joe@perches.com>
To: Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 07 Oct 2013 15:44:50 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Logging messages need terminating newlines to avoid
possible message interleaving.  Add them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index dd03cfe..dfb62e3 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -481,28 +481,28 @@ iscsi_iser_set_param(struct iscsi_cls_conn *cls_conn,
 	case ISCSI_PARAM_HDRDGST_EN:
 		sscanf(buf, "%d", &value);
 		if (value) {
-			iser_err("DataDigest wasn't negotiated to None");
+			iser_err("DataDigest wasn't negotiated to None\n");
 			return -EPROTO;
 		}
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
 		sscanf(buf, "%d", &value);
 		if (value) {
-			iser_err("DataDigest wasn't negotiated to None");
+			iser_err("DataDigest wasn't negotiated to None\n");
 			return -EPROTO;
 		}
 		break;
 	case ISCSI_PARAM_IFMARKER_EN:
 		sscanf(buf, "%d", &value);
 		if (value) {
-			iser_err("IFMarker wasn't negotiated to No");
+			iser_err("IFMarker wasn't negotiated to No\n");
 			return -EPROTO;
 		}
 		break;
 	case ISCSI_PARAM_OFMARKER_EN:
 		sscanf(buf, "%d", &value);
 		if (value) {
-			iser_err("OFMarker wasn't negotiated to No");
+			iser_err("OFMarker wasn't negotiated to No\n");
 			return -EPROTO;
 		}
 		break;


