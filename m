Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab3BLVUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:20:40 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:50405 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752499Ab3BLVUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:20:39 -0500
Message-ID: <1360704036.22660.5.camel@joe-AO722>
Subject: [PATCH] MAINTAINERS: Remove Jarod Wilson and orphan LIRC drivers
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        devel <devel@driverdev.osuosl.org>, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 12 Feb 2013 13:20:36 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

His email bounces and he hasn't done work on
these sections in a couple of years.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1d0651e..8d47b3a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7523,7 +7523,6 @@ F:	drivers/staging/comedi/
 
 STAGING - CRYSTAL HD VIDEO DECODER
 M:	Naren Sankar <nsankar@broadcom.com>
-M:	Jarod Wilson <jarod@wilsonet.com>
 M:	Scott Davilla <davilla@4pi.com>
 M:	Manu Abraham <abraham.manu@gmail.com>
 S:	Odd Fixes
@@ -7557,9 +7556,8 @@ S:	Odd Fixes
 F:	drivers/staging/iio/
 
 STAGING - LIRC (LINUX INFRARED REMOTE CONTROL) DRIVERS
-M:	Jarod Wilson <jarod@wilsonet.com>
 W:	http://www.lirc.org/
-S:	Odd Fixes
+S:	Orphan
 F:	drivers/staging/media/lirc/
 
 STAGING - NVIDIA COMPLIANT EMBEDDED CONTROLLER INTERFACE (nvec)


