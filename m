Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3ARVYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:24:44 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33582 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab3ARVYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:24:37 -0500
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-mm@kvack.org, ngupta@vflare.org,
        konrad.wilk@oracle.com, sjenning@linux.vnet.ibm.com,
        minchan@kernel.org, dan.magenheimer@oracle.com
Subject: [PATCH 4/5] staging: zcache: re-enable config/build of zcache after renaming
Date: Fri, 18 Jan 2013 13:24:26 -0800
Message-Id: <1358544267-9104-5-git-send-email-dan.magenheimer@oracle.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1358544267-9104-1-git-send-email-dan.magenheimer@oracle.com>
References: <1358544267-9104-1-git-send-email-dan.magenheimer@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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

