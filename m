Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaK2FeE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 00:34:04 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36230 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaK2FeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 00:34:03 -0500
From: Athira Lekshmi <andnlnbn18@gmail.com>
To: gregkh@linuxfoundation.org
Cc: eunb.song@samsung.com, paul.gortmaker@windriver.com, gulsah.1004@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Athira Lekshmi <andnlnbn18@gmail.com>
Subject: [PATCH] Drivers:staging:octeon: Fixed checkpatch warning
Date: Sat, 29 Nov 2014 11:04:00 +0530
Message-Id: <1417239240-12190-1-git-send-email-andnlnbn18@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning:
Missing a blank line after declarations

Signed-off-by: Athira Lekshmi <andnlnbn18@gmail.com>
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

