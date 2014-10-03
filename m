Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbaJCIVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 04:21:49 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:58845 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573AbaJCIVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 04:21:47 -0400
Message-ID: <1412324504.19413.76.camel@x220>
Subject: [PATCH] [next-20141003] USB: host: st: fix typo
 'CONFIG_USB_EHCI_HCD_ST'
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Peter Griffin <peter.griffin@linaro.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 03 Oct 2014 10:21:44 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Oct 2014 08:21:44.0799 (UTC) FILETIME=[1167C6F0:01CFDEE3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Fixes: 905e300e1043 ("USB: host: st: fix ehci/ohci driver selection")
---
drivers/usb/host/ehci-st.o actually builds (on x86_64. that is) so
there's no _obvious_ reason not to fix this typo.

 drivers/usb/host/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index 0336bb2c0e6f..3beda2655232 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -38,7 +38,7 @@ obj-$(CONFIG_USB_EHCI_MXC)	+= ehci-mxc.o
 obj-$(CONFIG_USB_EHCI_HCD_OMAP)	+= ehci-omap.o
 obj-$(CONFIG_USB_EHCI_HCD_ORION)	+= ehci-orion.o
 obj-$(CONFIG_USB_EHCI_HCD_SPEAR)	+= ehci-spear.o
-obj-$(CONFIG_USB_EHCI_HCD_ST)	+= ehci-st.o
+obj-$(CONFIG_USB_EHCI_HCD_STI)	+= ehci-st.o
 obj-$(CONFIG_USB_EHCI_EXYNOS)	+= ehci-exynos.o
 obj-$(CONFIG_USB_EHCI_HCD_AT91) += ehci-atmel.o
 obj-$(CONFIG_USB_EHCI_MSM)	+= ehci-msm.o
-- 
1.9.3

