Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaLEKzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:55:24 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:62408 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaLEKzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:55:23 -0500
From: Athira Lekshmi <andnlnbn18@gmail.com>
To: gregkh@linuxfoundation.org
Cc: eunb.song@samsung.com, paul.gortmaker@windriver.com, gulsah.1004@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Athira Lekshmi <andnlnbn18@gmail.com>
Subject: [PATCH] Drivers:staging:octeon: Fixed checkpatch warning
Date: Fri,  5 Dec 2014 16:25:22 +0530
Message-Id: <1417776922-2765-1-git-send-email-andnlnbn18@gmail.com>
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

