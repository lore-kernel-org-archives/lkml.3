Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805Ab3AQCyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:54:47 -0500
Received: from smtp.outflux.net ([198.145.64.163]:39289 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758521Ab3AQCyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:37 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Rob Landley <rob@landley.net>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 20/86] Documentation/laptops: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:12 -0800
Message-Id: <1358391258-1771-21-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358391258-1771-1-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Rob Landley <rob@landley.net>
CC: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/laptops/thinkpad-acpi.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
index 9d66682..cf7bc6c 100644
--- a/Documentation/laptops/thinkpad-acpi.txt
+++ b/Documentation/laptops/thinkpad-acpi.txt
@@ -1398,7 +1398,7 @@ Sysfs notes:
 EXPERIMENTAL: UWB
 -----------------
 
-This feature is marked EXPERIMENTAL because it has not been extensively
+This feature is considered EXPERIMENTAL because it has not been extensively
 tested and validated in various ThinkPad models yet.  The feature may not
 work as expected. USE WITH CAUTION! To use this feature, you need to supply
 the experimental=1 parameter when loading the module.
-- 
1.7.9.5

