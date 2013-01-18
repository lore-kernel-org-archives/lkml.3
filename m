Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab3ARVYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:24:48 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33601 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab3ARVYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:24:39 -0500
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-mm@kvack.org, ngupta@vflare.org,
        konrad.wilk@oracle.com, sjenning@linux.vnet.ibm.com,
        minchan@kernel.org, dan.magenheimer@oracle.com
Subject: [PATCH 1/5] staging: ramster: disable build in anticipation of renaming
Date: Fri, 18 Jan 2013 13:24:23 -0800
Message-Id: <1358544267-9104-2-git-send-email-dan.magenheimer@oracle.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1358544267-9104-1-git-send-email-dan.magenheimer@oracle.com>
References: <1358544267-9104-1-git-send-email-dan.magenheimer@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[V2: no code changes, patchset now generated via git format-patch -M]

In staging, disable ramster build in anticipation of renaming to zcache

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
---
 drivers/staging/Kconfig  |    2 --
 drivers/staging/Makefile |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index db8a512..eb61455 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -126,8 +126,6 @@ source "drivers/staging/csr/Kconfig"
 
 source "drivers/staging/omap-thermal/Kconfig"
 
-source "drivers/staging/ramster/Kconfig"
-
 source "drivers/staging/silicom/Kconfig"
 
 source "drivers/staging/ced1401/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index a9d5479..18420b8 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -55,7 +55,6 @@ obj-$(CONFIG_USB_G_CCG)		+= ccg/
 obj-$(CONFIG_WIMAX_GDM72XX)	+= gdm72xx/
 obj-$(CONFIG_CSR_WIFI)		+= csr/
 obj-$(CONFIG_OMAP_BANDGAP)	+= omap-thermal/
-obj-$(CONFIG_ZCACHE2)		+= ramster/
 obj-$(CONFIG_NET_VENDOR_SILICOM)	+= silicom/
 obj-$(CONFIG_CED1401)		+= ced1401/
 obj-$(CONFIG_DRM_IMX)		+= imx-drm/
-- 
1.7.1

