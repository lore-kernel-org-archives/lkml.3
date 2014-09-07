Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaIGSZl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 14:25:41 -0400
Received: from scspc499.cs.uwaterloo.ca ([129.97.171.80]:51230 "EHLO
	scspc499.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbaIGSZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 14:25:40 -0400
Date: Sun, 7 Sep 2014 14:25:35 -0400
From: anicoara <anicoara@uwaterloo.ca>
To: shigekatsu.tateno@atmel.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] staging: ozwpan: fix redundant return in void function
Message-ID: <20140907182535.GC2312@uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adrian Nicoara <anicoara@uwaterloo.ca>
---
Patch submitted as part of the Eudyptula challenge.

 drivers/staging/ozwpan/ozproto.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index cae0e6f..3d3a3a8 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -112,7 +112,6 @@ static void oz_send_conn_rsp(struct oz_pd *pd, u8 status)
 	}
 	oz_dbg(ON, "TX: OZ_ELT_CONNECT_RSP %d", status);
 	dev_queue_xmit(skb);
-	return;
 }

 /*
--
2.0.1

