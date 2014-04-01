Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaDAWAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 18:00:19 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:60038 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaDAWAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 18:00:17 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Eduardo Valentin <edubezval@gmail.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 1/1] MAINTAINER: Update email address on thermal subsystem
Date: Tue,  1 Apr 2014 18:03:54 -0400
Message-Id: <1396389834-52268-1-git-send-email-edubezval@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am updating my contact email address. For now on, patches
on non ACPI / SoC thermal must be sent to edubezval@gmail.com.

Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 79031a5..79d7981 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8741,7 +8741,7 @@ F:	drivers/media/radio/radio-raremono.c
 
 THERMAL
 M:	Zhang Rui <rui.zhang@intel.com>
-M:	Eduardo Valentin <eduardo.valentin@ti.com>
+M:	Eduardo Valentin <edubezval@gmail.com>
 L:	linux-pm@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git
@@ -8768,7 +8768,7 @@ S:	Maintained
 F:	drivers/platform/x86/thinkpad_acpi.c
 
 TI BANDGAP AND THERMAL DRIVER
-M:	Eduardo Valentin <eduardo.valentin@ti.com>
+M:	Eduardo Valentin <edubezval@gmail.com>
 L:	linux-pm@vger.kernel.org
 S:	Supported
 F:	drivers/thermal/ti-soc-thermal/
-- 
1.8.3.4 (Apple Git-47)

