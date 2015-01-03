Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbbACTOC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 14:14:02 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48787 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbbACTN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 14:13:59 -0500
From: Nishanth Menon <nm@ti.com>
To: Eduardo Valentin <edubezval@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Nishanth Menon <nm@ti.com>
Subject: [PATCH] MAINTAINERS: Add linux-omap to list of reviewers for TI Thermal
Date: Sat, 3 Jan 2015 13:13:30 -0600
Message-ID: <1420312410-4469-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add linux-omap mailing list to the TI THERMAL list for wider review.

Reported-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ddb9ac8..dc9efd5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9533,6 +9533,7 @@ F:	drivers/platform/x86/thinkpad_acpi.c
 TI BANDGAP AND THERMAL DRIVER
 M:	Eduardo Valentin <edubezval@gmail.com>
 L:	linux-pm@vger.kernel.org
+L:	linux-omap@vger.kernel.org
 S:	Supported
 F:	drivers/thermal/ti-soc-thermal/
 
-- 
1.7.9.5

