Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837AbaAJVHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 16:07:33 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:58774 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaAJVHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 16:07:30 -0500
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jan 2014 16:07:30 EST
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: linux-iio@vger.kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: [PATCH] iio:adc:max1363 clear list of missing features
Date: Fri, 10 Jan 2014 15:59:51 -0500
Message-Id: <1389387591-5534-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove "Control of internal reference" from the list of unimplemented
features, since as of commit a405b00, external reference is supported if
the device has a regulator and falls back to internal if it doesn't.

While we are modifying the header, let's make it more concise and remove
a redundant filename.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 drivers/iio/adc/max1363.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/adc/max1363.c b/drivers/iio/adc/max1363.c
index e283f2f..1228272 100644
--- a/drivers/iio/adc/max1363.c
+++ b/drivers/iio/adc/max1363.c
@@ -8,17 +8,11 @@
   * based on linux/drivers/acron/char/pcf8583.c
   * Copyright (C) 2000 Russell King
   *
+  * Driver for max1363 and similar chips.
+  *
   * This program is free software; you can redistribute it and/or modify
   * it under the terms of the GNU General Public License version 2 as
   * published by the Free Software Foundation.
-  *
-  * max1363.c
-  *
-  * Partial support for max1363 and similar chips.
-  *
-  * Not currently implemented.
-  *
-  * - Control of internal reference.
   */
 
 #include <linux/interrupt.h>
-- 
1.8.5.2

