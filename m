Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab3LTLFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 06:05:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58008 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab3LTLFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 06:05:32 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: kernel@pengutronix.de, Pavel Machek <pavel@ucw.cz>,
        Stephen Warren <swarren@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/2] reset: Add missing prototype for devm_reset_control_put
Date: Fri, 20 Dec 2013 12:05:25 +0100
Message-Id: <1387537525-23389-2-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387537525-23389-1-git-send-email-p.zabel@pengutronix.de>
References: <1387537525-23389-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 include/linux/reset.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/reset.h b/include/linux/reset.h
index 6082247..9b32334 100644
--- a/include/linux/reset.h
+++ b/include/linux/reset.h
@@ -11,6 +11,7 @@ int reset_control_deassert(struct reset_control *rstc);
 struct reset_control *reset_control_get(struct device *dev, const char *id);
 void reset_control_put(struct reset_control *rstc);
 struct reset_control *devm_reset_control_get(struct device *dev, const char *id);
+void devm_reset_control_put(struct reset_control *rstc);
 
 int device_reset(struct device *dev);
 
-- 
1.8.5.1

