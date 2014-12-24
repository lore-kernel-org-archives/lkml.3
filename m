Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaLXRXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 12:23:06 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36969 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbaLXRXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 12:23:02 -0500
From: Nishanth Menon <nm@ti.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 1/3] PM / OPP: export dev_pm_opp_get_notifier
Date: Wed, 24 Dec 2014 11:22:55 -0600
Message-ID: <1419441777-25651-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419441777-25651-1-git-send-email-nm@ti.com>
References: <1419441777-25651-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows user drivers such as devfreq to be modules.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/base/power/opp.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index d24dd614a..1b385e4 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -725,6 +725,7 @@ struct srcu_notifier_head *dev_pm_opp_get_notifier(struct device *dev)
 
 	return &dev_opp->srcu_head;
 }
+EXPORT_SYMBOL_GPL(dev_pm_opp_get_notifier);
 
 #ifdef CONFIG_OF
 /**
-- 
1.7.9.5

