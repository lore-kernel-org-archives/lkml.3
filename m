Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbaDUKLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:11:22 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:52177 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaDUKLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 06:11:18 -0400
From: Kefeng Wang <kefeng.wang@linaro.org>
To: Will Deacon <will.deacon@arm.com>, Robert Richter <rric@kernel.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, oprofile-list@lists.sf.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wangkefeng.wang@huawei.com
Subject: [PATCH] arm: oprofile: add ARMv7 cortex-a15 support
Date: Mon, 21 Apr 2014 18:11:04 +0800
Message-Id: <1398075064-4906-1-git-send-email-kefeng.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARMv7 cortex-a15 supports Performance Monitor Units, and
it could be used by oprofile, add perf_pmu_name pair.

Simply tested on hisilicon hip04 soc.

Signed-off-by: Kefeng Wang <kefeng.wang@linaro.org>
---
 arch/arm/oprofile/common.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 99c63d4b..9ede34b 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -39,6 +39,7 @@ static struct op_perf_name {
 	{ "v6mpcore",		"arm/mpcore"	},
 	{ "ARMv7 Cortex-A8",	"arm/armv7"	},
 	{ "ARMv7 Cortex-A9",	"arm/armv7-ca9"	},
+	{ "ARMv7 Cortex-A15",	"arm/armv7-ca15"},
 };
 
 char *op_name_from_perf_id(void)
-- 
1.7.9.5

