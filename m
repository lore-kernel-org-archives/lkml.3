Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaIPVrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:47:18 -0400
Received: from vidar.hosts.sieglitzhof.net ([62.113.200.140]:60258 "EHLO
	vidar.hosts.sieglitzhof.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754098AbaIPVrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:47:14 -0400
From: Maximilian Eschenbacher <maximilian@eschenbacher.email>
To: linux-kernel@vger.kernel.org
Cc: valentina.manea.m@gmail.com, shuah.kh@samsung.com,
        gregkh@linuxfoundation.org, Dominik Paulus <dominik.paulus@fau.de>,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>
Date: Tue, 16 Sep 2014 23:38:54 +0000
Message-Id: <1410910735-27929-18-git-send-email-maximilian@eschenbacher.email>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
X-SA-Exim-Connect-IP: 172.16.2.6
X-SA-Exim-Mail-From: maximilian@eschenbacher.email
Subject: [PATCH 17/18] usbip: Increment version number to 1.2.1
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on vidar.hosts.sieglitzhof.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dominik Paulus <dominik.paulus@fau.de>

Also increment the kernel module version number to match the
userspace version, as compatibility with old userspace utilities
is now at least partially broken.

Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
Signed-off-by: Fjodor Schelichow <fjodor.schelichow@hotmail.com>
Signed-off-by: Johannes Stadlinger <johannes.stadlinger@fau.de>
Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 drivers/usb/usbip/usbip_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/usbip/usbip_common.h b/drivers/usb/usbip/usbip_common.h
index 6831d99..a5f416e 100644
--- a/drivers/usb/usbip/usbip_common.h
+++ b/drivers/usb/usbip/usbip_common.h
@@ -32,7 +32,7 @@
 #include <uapi/linux/usbip.h>
 #include <linux/kfifo.h>
 
-#define USBIP_VERSION "1.0.0"
+#define USBIP_VERSION "1.2.1"
 
 /*
  * Length of the authentication tag associated with each packet, in bytes. Can
-- 
2.1.0

