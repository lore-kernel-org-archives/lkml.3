Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab3DLF42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 01:56:28 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:52752 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab3DLF40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 01:56:26 -0400
Message-ID: <1365746181.4025.3.camel@phoenix>
Subject: [RESEND][PATCH 3/3] PM / devfreq: exynos4_bus: Fix table entry size
 for exynos4x12_clkdiv_dmc1
From: Axel Lin <axel.lin@ingics.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 12 Apr 2013 13:56:21 +0800
In-Reply-To: <1365746058.4025.1.camel@phoenix>
References: <1365746058.4025.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exynos4x12_clkdiv_dmc1 contains { G2DACP, DIVC2C, DIVC2C_ACLK }, thus
set the size to 3 rather than 6.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/devfreq/exynos4_bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
index 45d00d1..1deee09 100644
--- a/drivers/devfreq/exynos4_bus.c
+++ b/drivers/devfreq/exynos4_bus.c
@@ -235,7 +235,7 @@ static const unsigned int exynos4x12_clkdiv_dmc0[][6] = {
 	/* DMC L4: 100MHz */
 	{7, 1, 1, 7, 1, 1},
 };
-static const unsigned int exynos4x12_clkdiv_dmc1[][6] = {
+static const unsigned int exynos4x12_clkdiv_dmc1[][3] = {
 	/*
 	 * Clock divider value for following
 	 * { G2DACP, DIVC2C, DIVC2C_ACLK }
-- 
1.7.9.5



