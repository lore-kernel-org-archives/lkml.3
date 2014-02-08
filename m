Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaBHH4p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 02:56:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:13411 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaBHHw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 02:52:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="477987527"
From: Andi Kleen <ak@linux.intel.com>
To: akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Douglas_Warzecha@dell.com
Subject: [PATCH 13/14] initconst: Fix initconst mistake in dcdbas
Date: Sat,  8 Feb 2014 08:52:09 +0100
Message-Id: <1391845930-28580-13-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

const must be __initconst

Cc: Douglas_Warzecha@dell.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/firmware/dcdbas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index 1b5e8e4..7160c43 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -584,7 +584,7 @@ static struct platform_driver dcdbas_driver = {
 	.remove		= dcdbas_remove,
 };
 
-static const struct platform_device_info dcdbas_dev_info __initdata = {
+static const struct platform_device_info dcdbas_dev_info __initconst = {
 	.name		= DRIVER_NAME,
 	.id		= -1,
 	.dma_mask	= DMA_BIT_MASK(32),
-- 
1.8.5.2

