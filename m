Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbaGKRs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:48:29 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:56750 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070AbaGKRs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:48:26 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: linux-mmc@vger.kernel.org, chris@printf.net, ulf.hansson@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH 2/3] mmc: sdhci-msm: Remove unnecessary header file inclusion
Date: Fri, 11 Jul 2014 20:48:12 +0300
Message-Id: <1405100893-32107-3-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405100893-32107-1-git-send-email-gdjakov@mm-sol.com>
References: <1405100893-32107-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header <linux/regulator/consumer.h> is unused. Remove it.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 drivers/mmc/host/sdhci-msm.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 40573a5..1a6661e 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -16,7 +16,6 @@
 
 #include <linux/module.h>
 #include <linux/of_device.h>
-#include <linux/regulator/consumer.h>
 #include <linux/delay.h>
 #include <linux/mmc/mmc.h>
 #include <linux/slab.h>
-- 
1.7.9.5

