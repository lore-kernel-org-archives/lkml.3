Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423102Ab3CVVCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 17:02:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36073 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423027Ab3CVVCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 17:02:05 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Zhang Rui <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 02/11] thermal: update driver license
Date: Fri, 22 Mar 2013 17:00:45 -0400
Message-ID: <1363986054-24637-3-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363986054-24637-1-git-send-email-eduardo.valentin@ti.com>
References: <1363986054-24637-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per the comment at the top of this file, this is a GPLv2 driver.
This patch updates the driver license accordingly.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/thermal_sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 7875607..9542600 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -40,7 +40,7 @@
 
 MODULE_AUTHOR("Zhang Rui");
 MODULE_DESCRIPTION("Generic thermal management sysfs support");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 
 static DEFINE_IDR(thermal_tz_idr);
 static DEFINE_IDR(thermal_cdev_idr);
-- 
1.7.7.1.488.ge8e1c

