Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbaDYNkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:40:47 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:40011 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbaDYNkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:40:45 -0400
From: Nicolas Del Piano <ndel314@gmail.com>
To: gregkh@linuxfoundation.org
Cc: aaro.koskinen@iki.fi, devendra.aaru@gmail.com, raluca.oncioiu91@gmail.com,
        david.daney@cavium.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Nicolas Del Piano <ndel314@gmail.com>
Subject: [PATCH] Staging: octeon-usb: fixed a macro coding style issue
Date: Fri, 25 Apr 2014 10:40:33 -0300
Message-Id: <1398433233-2749-1-git-send-email-ndel314@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style error, macros with comples values should be enclosed in parenthesis.

Signed-off-by: Nicolas Del Piano <ndel314@gmail.com>
---
 drivers/staging/octeon-usb/octeon-hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon-usb/octeon-hcd.c b/drivers/staging/octeon-usb/octeon-hcd.c
index 8b8ce72..475ecc4 100644
--- a/drivers/staging/octeon-usb/octeon-hcd.c
+++ b/drivers/staging/octeon-usb/octeon-hcd.c
@@ -246,7 +246,7 @@ enum cvmx_usb_pipe_flags {
 };

 /* Normal prefetch that use the pref instruction. */
-#define CVMX_PREFETCH(address, offset) asm volatile ("pref %[type], %[off](%[rbase])" : : [rbase] "d" (address), [off] "I" (offset), [type] "n" (0))
+#define (CVMX_PREFETCH(address, offset) asm volatile ("pref %[type], %[off](%[rbase])" : : [rbase] "d" (address), [off] "I" (offset), [type] "n" (0)))

 /* Maximum number of times to retry failed transactions */
 #define MAX_RETRIES		3
--
1.7.9.5

