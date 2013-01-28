Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab3A1S03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:26:29 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45517 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab3A1S0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:26:19 -0500
From: Nishanth Menon <nm@ti.com>
To: linux-pm <linux-pm@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>, Rafael <rjw@sisk.pl>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 1/2] PM / OPP: switch exported symbols to GPL variant
Date: Mon, 28 Jan 2013 12:26:15 -0600
Message-ID: <1359397576-26131-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359397576-26131-1-git-send-email-nm@ti.com>
References: <1359397576-26131-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are GPLV2 library, so be clear in the symbols exported as well.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/base/power/opp.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 50b2831..0dbe270 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -162,7 +162,7 @@ unsigned long opp_get_voltage(struct opp *opp)
 
 	return v;
 }
-EXPORT_SYMBOL(opp_get_voltage);
+EXPORT_SYMBOL_GPL(opp_get_voltage);
 
 /**
  * opp_get_freq() - Gets the frequency corresponding to an available opp
@@ -192,7 +192,7 @@ unsigned long opp_get_freq(struct opp *opp)
 
 	return f;
 }
-EXPORT_SYMBOL(opp_get_freq);
+EXPORT_SYMBOL_GPL(opp_get_freq);
 
 /**
  * opp_get_opp_count() - Get number of opps available in the opp list
@@ -225,7 +225,7 @@ int opp_get_opp_count(struct device *dev)
 
 	return count;
 }
-EXPORT_SYMBOL(opp_get_opp_count);
+EXPORT_SYMBOL_GPL(opp_get_opp_count);
 
 /**
  * opp_find_freq_exact() - search for an exact frequency
@@ -276,7 +276,7 @@ struct opp *opp_find_freq_exact(struct device *dev, unsigned long freq,
 
 	return opp;
 }
-EXPORT_SYMBOL(opp_find_freq_exact);
+EXPORT_SYMBOL_GPL(opp_find_freq_exact);
 
 /**
  * opp_find_freq_ceil() - Search for an rounded ceil freq
@@ -323,7 +323,7 @@ struct opp *opp_find_freq_ceil(struct device *dev, unsigned long *freq)
 
 	return opp;
 }
-EXPORT_SYMBOL(opp_find_freq_ceil);
+EXPORT_SYMBOL_GPL(opp_find_freq_ceil);
 
 /**
  * opp_find_freq_floor() - Search for a rounded floor freq
@@ -374,7 +374,7 @@ struct opp *opp_find_freq_floor(struct device *dev, unsigned long *freq)
 
 	return opp;
 }
-EXPORT_SYMBOL(opp_find_freq_floor);
+EXPORT_SYMBOL_GPL(opp_find_freq_floor);
 
 /**
  * opp_add()  - Add an OPP table from a table definitions
@@ -568,7 +568,7 @@ int opp_enable(struct device *dev, unsigned long freq)
 {
 	return opp_set_availability(dev, freq, true);
 }
-EXPORT_SYMBOL(opp_enable);
+EXPORT_SYMBOL_GPL(opp_enable);
 
 /**
  * opp_disable() - Disable a specific OPP
@@ -590,7 +590,7 @@ int opp_disable(struct device *dev, unsigned long freq)
 {
 	return opp_set_availability(dev, freq, false);
 }
-EXPORT_SYMBOL(opp_disable);
+EXPORT_SYMBOL_GPL(opp_disable);
 
 #ifdef CONFIG_CPU_FREQ
 /**
-- 
1.7.9.5

