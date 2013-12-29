Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab3L2Cdy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:33:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55384 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672Ab3L2CKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:46 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ohad Ben-Cohen" <ohad@wizery.com>,
        "Anna, Suman" <s-anna@ti.com>, "Hebbar, Shivananda" <x0hebbar@ti.com>,
        "Kanigeri, Hari" <h-kanigeri2@ti.com>,
        "Gomez Castellanos, Ivan" <ivan.gomez@ti.com>,
        "Deepak Chitriki" <deepak.chitriki@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Ramos Falcon, Ernesto" <ernesto@ti.com>,
        "Nico Golde" <nico@ngolde.de>,
        "Andy Shevchenko" <ext-andriy.shevchenko@nokia.com>,
        "Menon, Nishanth" <nm@ti.com>,
        "Phil Carmody" <ext-phil.2.carmody@nokia.com>,
        "Omar Ramirez Luna" <omar.ramirez@copitl.com>,
        "Gupta, Ramesh" <grgupta@ti.com>,
        "Felipe Contreras" <felipe.contreras@gmail.com>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        "Omar Ramirez Luna" <omar.ramirez@ti.com>,
        "Armando Uribe De Leon" <x0095078@ti.com>,
        "Ameya Palande" <ameya.palande@nokia.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.23887801@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 102/185] Staging: tidspbridge: disable driver
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context; no dependency on !ARCH_MULTIPLATFORM]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/tidspbridge/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

