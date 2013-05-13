Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab3EMRzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 13:55:07 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:36731 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab3EMRzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 13:55:05 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Federico Vaga <federico.vaga@gmail.com>
Subject: [PATCH] dwc2/pci.c: add STMICRO vendor and device ID for STA2X11 board
Date: Mon, 13 May 2013 19:54:12 +0200
Message-Id: <1368467652-19940-1-git-send-email-federico.vaga@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 drivers/staging/dwc2/pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/dwc2/pci.c b/drivers/staging/dwc2/pci.c
index 69c65eb..7029b9f 100644
--- a/drivers/staging/dwc2/pci.c
+++ b/drivers/staging/dwc2/pci.c
@@ -162,6 +162,10 @@ static DEFINE_PCI_DEVICE_TABLE(dwc2_pci_ids) = {
 	{
 		PCI_DEVICE(PCI_VENDOR_ID_SYNOPSYS, PCI_PRODUCT_ID_HAPS_HSOTG),
 	},
+	{
+		PCI_DEVICE(PCI_VENDOR_ID_STMICRO,
+			   PCI_DEVICE_ID_STMICRO_USB_OTG),
+	},
 	{ /* end: all zeroes */ }
 };
 MODULE_DEVICE_TABLE(pci, dwc2_pci_ids);
-- 
1.8.1.4

