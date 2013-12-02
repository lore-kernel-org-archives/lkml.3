Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618Ab3LBVTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:19:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab3LBTMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:12:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nico Golde <nico@ngolde.de>, Dan Carpenter <dan.carpenter@oracle.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        "Kanigeri, Hari" <h-kanigeri2@ti.com>,
        Ameya Palande <ameya.palande@nokia.com>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        "Hebbar, Shivananda" <x0hebbar@ti.com>,
        "Ramos Falcon, Ernesto" <ernesto@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        "Anna, Suman" <s-anna@ti.com>, "Gupta, Ramesh" <grgupta@ti.com>,
        "Gomez Castellanos, Ivan" <ivan.gomez@ti.com>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Armando Uribe De Leon <x0095078@ti.com>,
        Deepak Chitriki <deepak.chitriki@ti.com>,
        "Menon, Nishanth" <nm@ti.com>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 3.10 009/173] Staging: tidspbridge: disable driver
Date: Mon,  2 Dec 2013 11:09:52 -0800
Message-Id: <20131202191143.997826119@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 930ba4a374b96560ef9fde2145cdc454a164ddcc upstream.

There seems to be no active maintainer for the driver, and there is an
unfixed security bug, so disable the driver for now.

Hopefully someone steps up to be the maintainer, and works to get this
out of staging, otherwise it will be deleted soon.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Omar Ramirez Luna <omar.ramirez@copitl.com>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: Kanigeri, Hari <h-kanigeri2@ti.com>
Cc: Ameya Palande <ameya.palande@nokia.com>
Cc: Guzman Lugo, Fernando <fernando.lugo@ti.com>
Cc: Hebbar, Shivananda <x0hebbar@ti.com>
Cc: Ramos Falcon, Ernesto <ernesto@ti.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Anna, Suman <s-anna@ti.com>
Cc: Gupta, Ramesh <grgupta@ti.com>
Cc: Gomez Castellanos, Ivan <ivan.gomez@ti.com>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Armando Uribe De Leon <x0095078@ti.com>
Cc: Deepak Chitriki <deepak.chitriki@ti.com>
Cc: Menon, Nishanth <nm@ti.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/tidspbridge/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/tidspbridge/Kconfig
+++ b/drivers/staging/tidspbridge/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig TIDSPBRIDGE
 	tristate "DSP Bridge driver"
-	depends on ARCH_OMAP3 && !ARCH_MULTIPLATFORM
+	depends on ARCH_OMAP3 && !ARCH_MULTIPLATFORM && BROKEN
 	select OMAP_MBOX_FWK
 	help
 	  DSP/BIOS Bridge is designed for platforms that contain a GPP and


