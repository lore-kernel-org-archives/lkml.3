Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760322AbaEMJnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:43:25 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60882 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760107AbaEMJ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 092/182] media: m88rs2000: add caps FE_CAN_INVERSION_AUTO
Date: Tue, 13 May 2014 11:27:24 +0200
Message-Id: <73b6c8b3381671cdd2d64b6255eba8bbdb9042d7.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Malcolm Priestley <tvboxspy@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3c8023a782964c72574ad8268ba0ea4e2d9772fc upstream.

The m88rs2000 frontend is always auto inversion.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/dvb-frontends/m88rs2000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index acd4ff58f902..c7a1c8eba475 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -759,7 +759,7 @@ static struct dvb_frontend_ops m88rs2000_ops = {
 		.symbol_rate_tolerance	= 500,	/* ppm */
 		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 		      FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 |
-		      FE_CAN_QPSK |
+		      FE_CAN_QPSK | FE_CAN_INVERSION_AUTO |
 		      FE_CAN_FEC_AUTO
 	},
 
-- 
1.9.3

