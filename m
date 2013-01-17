Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3AQRcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:32:24 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18686 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab3AQRcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:32:23 -0500
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-mm@kvack.org, ngupta@vflare.org,
        konrad.wilk@oracle.com, sjenning@linux.vnet.ibm.com,
        minchan@kernel.org, dan.magenheimer@oracle.com
Subject: [PATCH 4/5] staging: zcache: re-enable config/build of zcache after renaming
Date: Thu, 17 Jan 2013 09:26:36 -0800
Message-Id: <1358443597-9845-5-git-send-email-dan.magenheimer@oracle.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1358443597-9845-1-git-send-email-dan.magenheimer@oracle.com>
References: <1358443597-9845-1-git-send-email-dan.magenheimer@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In staging, re-enable config/build of zcache after ramster->zcache renaming.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
---
 drivers/staging/Kconfig  |    2 ++
 drivers/staging/Makefile |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index eb61455..0b47a06 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -138,4 +138,6 @@ source "drivers/staging/sb105x/Kconfig"
 
 source "drivers/staging/fwserial/Kconfig"
 
+source "drivers/staging/zcache/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 18420b8..b026ea3 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -61,3 +61,4 @@ obj-$(CONFIG_DRM_IMX)		+= imx-drm/
 obj-$(CONFIG_DGRP)		+= dgrp/
 obj-$(CONFIG_SB105X)		+= sb105x/
 obj-$(CONFIG_FIREWIRE_SERIAL)	+= fwserial/
+obj-$(CONFIG_ZCACHE)		+= zcache/
-- 
1.7.1

