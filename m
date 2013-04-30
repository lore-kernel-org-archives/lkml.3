Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986Ab3D3JkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 05:40:24 -0400
Received: from mout.gmx.net ([212.227.15.15]:55644 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758998Ab3D3JkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 05:40:23 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX18Ei1s46LYEg8AbNafv0h2b6yD9vZu6WVheMqHEFB
	GFKLwleZmPigJA
From: dl9pf@gmx.de
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        lenb@kernel.org
Cc: dl9pf@gmx.de
Subject: [PATCH] Fix section to __init. Align with usage in acpixf.h . Fixes warning during compilation with clang.
Date: Tue, 30 Apr 2013 11:39:04 +0200
Message-Id: <1367314744-9659-1-git-send-email-dl9pf@gmx.de>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
---
 include/acpi/acpiosxf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index 5b3d2bd..64b8c76 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -77,7 +77,7 @@ struct acpi_signal_fatal_info {
 /*
  * OSL Initialization and shutdown primitives
  */
-acpi_status __initdata acpi_os_initialize(void);
+acpi_status __init acpi_os_initialize(void);
 
 acpi_status acpi_os_terminate(void);
 
-- 
1.8.1.4

