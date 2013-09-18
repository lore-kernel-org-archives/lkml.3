Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab3IRQFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 12:05:40 -0400
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:59723 "EHLO
	mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896Ab3IRQFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 12:05:39 -0400
X-RRZE-Submit-IP: 131.188.42.153
From: Tobias Polzer <tobias.polzer@fau.de>
To: linux-kernel@vger.kernel.org
Cc: linux-kernel@i4.cs.fau.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tobias Polzer <tobias.polzer@fau.de>,
        Dominik Paulus <dominik.paulus@fau.de>
Subject: [PATCH] staging: usbip: Orphan usbip
Date: Wed, 18 Sep 2013 18:04:59 +0200
Message-Id: <1379520299-31284-1-git-send-email-tobias.polzer@fau.de>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The domain of Matt Mooneey's email doesn't exist anymore.
Setting usbip to Oprhan.

Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e61c2e8..5eb35c3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8724,9 +8724,8 @@ F:	Documentation/hid/hiddev.txt
 F:	drivers/hid/usbhid/
 
 USB/IP DRIVERS
-M:	Matt Mooney <mfm@muteddisk.com>
 L:	linux-usb@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	drivers/staging/usbip/
 
 USB ISP116X DRIVER
-- 
1.8.4.rc3

