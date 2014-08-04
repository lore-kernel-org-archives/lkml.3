Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaHDNCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:02:55 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.102]:50923 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaHDNCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:02:53 -0400
From: Christoph Jaeger <email@christophjaeger.info>
To: shigekatsu.tateno@atmel.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <email@christophjaeger.info>
Subject: [PATCH 03/10] staging: ozwpan: Remove unused OZ_MAX_TIMER_POOL_SIZE
Date: Mon,  4 Aug 2014 14:54:49 +0200
Message-Id: <1407156896-3246-4-git-send-email-email@christophjaeger.info>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
References: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OZ_MAX_TIMER_POOL_SIZE is not used anywhere; remove it.

Signed-off-by: Christoph Jaeger <email@christophjaeger.info>
---
 drivers/staging/ozwpan/ozproto.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index 1102055..4aebe16 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -29,8 +29,6 @@
 #define OZ_DO_STOP		1
 #define OZ_DO_SLEEP		2
 
-#define OZ_MAX_TIMER_POOL_SIZE	16
-
 struct oz_binding {
 	struct packet_type ptype;
 	char name[OZ_MAX_BINDING_LEN];
-- 
1.9.1

