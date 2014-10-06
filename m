Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaJFJKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:10:52 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:52867 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbaJFJKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:10:49 -0400
Message-ID: <1412586646.4054.43.camel@x220>
Subject: [PATCH 4/4] usb: host: Remove optional dependencies on PLAT_S5P
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 06 Oct 2014 11:10:46 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2014 09:10:46.0623 (UTC) FILETIME=[6A1BBEF0:01CFE145]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d78c16ccde96 ("ARM: SAMSUNG: Remove remaining legacy code")
removed the Kconfig symbol PLAT_S5P. Remove two optional dependencies on
that symbol from this Kconfig file too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/usb/host/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 31f9b1118e9d..82cc61af4a23 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -229,7 +229,7 @@ config USB_EHCI_SH
 
 config USB_EHCI_EXYNOS
        tristate "EHCI support for Samsung S5P/EXYNOS SoC Series"
-       depends on PLAT_S5P || ARCH_EXYNOS
+       depends on ARCH_EXYNOS
        help
 	Enable support for the Samsung Exynos SOC's on-chip EHCI controller.
 
@@ -545,7 +545,7 @@ config USB_OHCI_SH
 
 config USB_OHCI_EXYNOS
 	tristate "OHCI support for Samsung S5P/EXYNOS SoC Series"
-	depends on PLAT_S5P || ARCH_EXYNOS
+	depends on ARCH_EXYNOS
 	help
 	 Enable support for the Samsung Exynos SOC's on-chip OHCI controller.
 
-- 
1.9.3

