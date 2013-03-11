Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3CKOVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:21:30 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:60691 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab3CKOV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:21:29 -0400
MIME-Version: 1.0
Date: Mon, 11 Mar 2013 22:21:28 +0800
Message-ID: <CAPgLHd9QgppJ1mR3F6jkTJYOZLD5rbJwcy+KEEZSjtVPtHHdRw@mail.gmail.com>
Subject: [PATCH -next] x86, io_apic: remove duplicated include from irq_remapping.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: joro@8bytes.org, konrad.wilk@oracle.com, sebastian@breakpoint.cc,
        suresh.b.siddha@intel.com, yinghai@kernel.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/iommu/irq_remapping.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index d56f8c1..7c11ff3 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -2,7 +2,6 @@
 #include <linux/cpumask.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/cpumask.h>
 #include <linux/errno.h>
 #include <linux/msi.h>
 #include <linux/irq.h>

