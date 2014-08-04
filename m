Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaHDNBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:01:47 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.104]:50820 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaHDNBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:01:46 -0400
From: Christoph Jaeger <email@christophjaeger.info>
To: shigekatsu.tateno@atmel.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <email@christophjaeger.info>
Subject: [PATCH 02/10] staging: ozwpan: Fix typo in typedef
Date: Mon,  4 Aug 2014 14:54:48 +0200
Message-Id: <1407156896-3246-3-git-send-email-email@christophjaeger.info>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
References: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Jaeger <email@christophjaeger.info>
---
 drivers/staging/ozwpan/ozproto.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ozwpan/ozproto.h b/drivers/staging/ozwpan/ozproto.h
index cb38e02..378b737 100644
--- a/drivers/staging/ozwpan/ozproto.h
+++ b/drivers/staging/ozwpan/ozproto.h
@@ -34,7 +34,7 @@ typedef void (*oz_app_term_fn_t)(void);
 typedef int (*oz_app_start_fn_t)(struct oz_pd *pd, int resume);
 typedef void (*oz_app_stop_fn_t)(struct oz_pd *pd, int pause);
 typedef void (*oz_app_rx_fn_t)(struct oz_pd *pd, struct oz_elt *elt);
-typedef int (*oz_app_hearbeat_fn_t)(struct oz_pd *pd);
+typedef int (*oz_app_heartbeat_fn_t)(struct oz_pd *pd);
 typedef void (*oz_app_farewell_fn_t)(struct oz_pd *pd, u8 ep_num,
 			u8 *data, u8 len);
 
@@ -44,7 +44,7 @@ struct oz_app_if {
 	oz_app_start_fn_t	start;
 	oz_app_stop_fn_t	stop;
 	oz_app_rx_fn_t		rx;
-	oz_app_hearbeat_fn_t	heartbeat;
+	oz_app_heartbeat_fn_t	heartbeat;
 	oz_app_farewell_fn_t	farewell;
 	int			app_id;
 };
-- 
1.9.1

