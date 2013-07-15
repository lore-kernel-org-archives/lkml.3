Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3GOAnv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 20:43:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58605 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab3GOAnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 20:43:50 -0400
Message-ID: <51E3459A.7070909@infradead.org>
Date: Sun, 14 Jul 2013 17:43:06 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] driver-core: fix new kernel-doc warning in base/platform.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix new kernel-doc warning in drivers/base/platform.c:

Warning(drivers/base/platform.c:528): No description found for parameter 'owner'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/base/platform.c |    1 +
 1 file changed, 1 insertion(+)

--- lnx-311-rc1.orig/drivers/base/platform.c
+++ lnx-311-rc1/drivers/base/platform.c
@@ -522,6 +522,7 @@ static void platform_drv_shutdown(struct
 /**
  * __platform_driver_register - register a driver for platform-level devices
  * @drv: platform driver structure
+ * @owner: owning module/driver
  */
 int __platform_driver_register(struct platform_driver *drv,
 				struct module *owner)
