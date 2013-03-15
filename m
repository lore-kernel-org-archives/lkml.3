Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab3CONSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:18:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42926 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab3CONSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:18:09 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 46/50] staging: Add a MAINTAINERS entry for TI bandgap and thermal driver
Date: Fri, 15 Mar 2013 09:00:34 -0400
Message-ID: <1363352438-15935-47-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add myself as maintainer of the TI bandgap and thermal driver.

CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Zhang Rui <rui.zhang@intel.com>

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6672165..199bb4b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7915,6 +7915,12 @@ T:	git git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git
 S:	Maintained
 F:	drivers/platform/x86/thinkpad_acpi.c
 
+TI BANDGAP AND THERMAL DRIVER
+M:	Eduardo Valentin <eduardo.valentin@ti.com>
+L:	linux-pm@vger.kernel.org
+S:	Maintained
+F:	drivers/staging/omap-thermal/
+
 TI FLASH MEDIA INTERFACE DRIVER
 M:	Alex Dubov <oakad@yahoo.com>
 S:	Maintained
-- 
1.7.7.1.488.ge8e1c

