Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492AbaDVU3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:29:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36744 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721AbaDVUZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:25:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 041/133] [media] m88rs2000: add caps FE_CAN_INVERSION_AUTO
Date: Tue, 22 Apr 2014 13:12:59 -0700
Message-Id: <1398197671-12786-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 3c8023a782964c72574ad8268ba0ea4e2d9772fc upstream.

The m88rs2000 frontend is always auto inversion.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/dvb-frontends/m88rs2000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index 633815e..483ffe7 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -856,7 +856,7 @@ static struct dvb_frontend_ops m88rs2000_ops = {
 		.symbol_rate_tolerance	= 500,	/* ppm */
 		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 		      FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 |
-		      FE_CAN_QPSK |
+		      FE_CAN_QPSK | FE_CAN_INVERSION_AUTO |
 		      FE_CAN_FEC_AUTO
 	},
 
-- 
1.9.1

