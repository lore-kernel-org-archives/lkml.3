Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbaENQCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:02:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50505 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbaENQCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:02:45 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH RESEND 2/2] cpufreq: imx6q: Remove unused include
Date: Wed, 14 May 2014 18:02:24 +0200
Message-Id: <1400083344-20042-2-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.0.0.rc0
In-Reply-To: <1400083344-20042-1-git-send-email-p.zabel@pengutronix.de>
References: <1400083344-20042-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to include delay.h.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Shawn Guo <shawn.guo@freescale.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/cpufreq/imx6q-cpufreq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index 92a82ec..af366c2 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -9,7 +9,6 @@
 #include <linux/clk.h>
 #include <linux/cpu.h>
 #include <linux/cpufreq.h>
-#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/of.h>
-- 
2.0.0.rc0

