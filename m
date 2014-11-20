Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbaKTSBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 13:01:24 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:39631 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658AbaKTSBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 13:01:23 -0500
From: Lekshmi <andnlnbn18@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Lekshmi <andnlnbn18@gmail.com>
Subject: [PATCH] Drivers:Staging:octeon: Fixed missing a blank line warning
Date: Thu, 20 Nov 2014 23:31:14 +0530
Message-Id: <1416506474-27241-1-git-send-email-andnlnbn18@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following checkpatch warning was fixed:
WARNING: Missing a blank line after declarations

Signed-off-by: Lekshmi <andnlnbn18@gmail.com>
---
 drivers/staging/octeon/ethernet-rx.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 44e372f..220106e 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -84,6 +84,7 @@ static int cvm_irq_cpu;
 static void cvm_oct_enable_napi(void *_)
 {
 	int cpu = smp_processor_id();
+
 	napi_schedule(&cvm_oct_napi[cpu].napi);
 }
 
-- 
1.7.9.5

