Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506Ab3EOPq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:46:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46345 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759473Ab3EOPqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:46:54 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>, <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devel@driverdev.osuosl.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 2/2] MAINTAINERS: update TI SoC thermal driver entry
Date: Wed, 15 May 2013 11:46:01 -0400
Message-ID: <1368632761-10528-3-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1368632761-10528-1-git-send-email-eduardo.valentin@ti.com>
References: <1368632761-10528-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update driver path and status for TI SoC thermal drivers
on MAINTAINERS file.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bc3d340..2b8a7c5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8056,8 +8056,8 @@ F:	drivers/platform/x86/thinkpad_acpi.c
 TI BANDGAP AND THERMAL DRIVER
 M:	Eduardo Valentin <eduardo.valentin@ti.com>
 L:	linux-pm@vger.kernel.org
-S:	Maintained
-F:	drivers/staging/omap-thermal/
+S:	Supported
+F:	drivers/thermal/ti-soc-thermal/
 
 TI FLASH MEDIA INTERFACE DRIVER
 M:	Alex Dubov <oakad@yahoo.com>
-- 
1.8.2.1.342.gfa7285d

