Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab3LERlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:41:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38462 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933438Ab3LERiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:38:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Omar Ramirez Luna <omar.ramirez@copitl.com>,
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
        Ohad Ben-Cohen <ohad@wizery.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 83/90] Staging: tidspbridge: disable driver
Date: Thu,  5 Dec 2013 17:36:05 +0000
Message-Id: <1386264972-5399-84-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/tidspbridge/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/tidspbridge/Kconfig b/drivers/staging/tidspbridge/Kconfig
index 0dd479f..f67c78e 100644
--- a/drivers/staging/tidspbridge/Kconfig
+++ b/drivers/staging/tidspbridge/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig TIDSPBRIDGE
 	tristate "DSP Bridge driver"
-	depends on ARCH_OMAP3
+	depends on ARCH_OMAP3 && BROKEN
 	select OMAP_MBOX_FWK
 	help
 	  DSP/BIOS Bridge is designed for platforms that contain a GPP and
-- 
1.8.3.2

