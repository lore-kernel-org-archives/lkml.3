Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3CJB7r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 20:59:47 -0500
Received: from intranet.asianux.com ([58.214.24.6]:46163 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab3CJB7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 20:59:46 -0500
X-Spam-Score: -100.8
Message-ID: <513BE8FA.6080304@asianux.com>
Date: Sun, 10 Mar 2013 09:59:22 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linus.walleij@linaro.org, rob.herring@calxeda.com,
        marc.zyngier@arm.com, shawn.guo@linaro.org
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM:kernel: beautify code, using 'static const' instead of
 'const static'
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  better using 'static const' instead of 'const static'

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arm/kernel/smp_twd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 3f25650..ef3e499 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -362,7 +362,7 @@ int __init twd_local_timer_register(struct twd_local_timer *tlt)
 }
 
 #ifdef CONFIG_OF
-const static struct of_device_id twd_of_match[] __initconst = {
+static const struct of_device_id twd_of_match[] __initconst = {
 	{ .compatible = "arm,cortex-a9-twd-timer",	},
 	{ .compatible = "arm,cortex-a5-twd-timer",	},
 	{ .compatible = "arm,arm11mp-twd-timer",	},
-- 
1.7.7.6
