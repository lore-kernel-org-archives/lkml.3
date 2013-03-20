Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab3CTIX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 04:23:56 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:49425 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab3CTIXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 04:23:54 -0400
Message-ID: <1363767334.3758.5.camel@phoenix>
Subject: [PATCH 2/2] PM / devfreq: exynos4_bus: Fix table entry size for
 exynos4x12_clkdiv_dmc1
From: Axel Lin <axel.lin@ingics.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>, linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 16:15:34 +0800
In-Reply-To: <1363767266.3758.4.camel@phoenix>
References: <1363767266.3758.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
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



