Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaFYE6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 00:58:30 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:46533 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaFYE63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 00:58:29 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH 1/4] staging: lustre: llite: llite_capa.c - fixes checkpatch errors - unecessary init of static variables to 0
Date: Wed, 25 Jun 2014 14:57:27 +1000
Message-Id: <1403672250-19048-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- this commit fixes some "ERROR: do not initialise statics to 0 or NULL"

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/llite/llite_capa.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_capa.c b/drivers/staging/lustre/lustre/llite/llite_capa.c
index d06d0b1..7ed45a4 100644
--- a/drivers/staging/lustre/lustre/llite/llite_capa.c
+++ b/drivers/staging/lustre/lustre/llite/llite_capa.c
@@ -63,10 +63,10 @@ static struct list_head *ll_capa_list = &capa_list[CAPA_SITE_CLIENT];
 struct timer_list ll_capa_timer;
 /* for debug: indicate whether capa on llite is enabled or not */
 static atomic_t ll_capa_debug = ATOMIC_INIT(0);
-static unsigned long long ll_capa_renewed = 0;
-static unsigned long long ll_capa_renewal_noent = 0;
-static unsigned long long ll_capa_renewal_failed = 0;
-static unsigned long long ll_capa_renewal_retries = 0;
+static unsigned long long ll_capa_renewed;
+static unsigned long long ll_capa_renewal_noent;
+static unsigned long long ll_capa_renewal_failed;
+static unsigned long long ll_capa_renewal_retries;
 
 static int ll_update_capa(struct obd_capa *ocapa, struct lustre_capa *capa);
 
-- 
1.9.0

