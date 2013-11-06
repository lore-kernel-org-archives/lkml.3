Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab3KFMT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:19:28 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9088 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390Ab3KFMTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:19:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 06 Nov 2013 04:18:22 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lee.jones@linaro.org>, <sameo@linux.intel.com>, <mturquette@linaro.org>,
        <dwmw2@infradead.org>, <anton@enomsg.org>
CC: <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <rob.herring@calxeda.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 1/5] mfd: as3722: add clock driver as mfd-sub device
Date: Wed, 6 Nov 2013 17:48:19 +0530
Message-ID: <1383740303-10956-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1383740303-10956-1-git-send-email-ldewangan@nvidia.com>
References: <1383740303-10956-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device ams AS3722 supports the one 32KHz clock output. The clock
control support is provided through clock driver.

Add clock driver as mfd sub device to probe the clock driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Move the DT doc change to separate change.

 drivers/mfd/as3722.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/as3722.c b/drivers/mfd/as3722.c
index f161f2e..1d3415c 100644
--- a/drivers/mfd/as3722.c
+++ b/drivers/mfd/as3722.c
@@ -72,6 +72,9 @@ static struct mfd_cell as3722_devs[] = {
 		.resources = as3722_adc_resource,
 	},
 	{
+		.name = "as3722-clk",
+	},
+	{
 		.name = "as3722-power-off",
 	},
 };
-- 
1.7.1.1

