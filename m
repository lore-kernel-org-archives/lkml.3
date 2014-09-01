Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbaIAPEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:04:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39148 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbaIAPEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:04:21 -0400
X-AuditID: cbfee61a-f79e46d00000134f-8c-54048af39a08
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Pratyush Anand <pratyush.anand@st.com>, Mohit Kumar <mohit.kumar@st.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] phy: spear1340-miphy: fix driver dependencies
Date: Mon, 01 Sep 2014 17:04:15 +0200
Message-id: <1471344.eQaNhMq6lM@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd3PXSwhBi+mS1lceNrDZnG26Q27
	xeVdc9gsNk79xWjRfknZgdWjb8sqRo+nP/Yyexy/sZ3J4/MmuQCWKC6blNSczLLUIn27BK6M
	Py/3shXcZKuY1v6ApYHxBmsXIyeHhICJxIRt66FsMYkL99azdTFycQgJLGKUWLzgMZTTwiSx
	aX0fG0gVm4CVxMT2VYwgtoiAlsTpnT+YQYqYBaYzSrx8Nx1slLCAncTSr5+YQGwWAVWJT63v
	wWxeAU2JHx/3gDWLCnhK7Ni+kg0iLijxY/I9FhCbWUBeYt/+qawQtpbE+p3HmSYw8s1CUjYL
	SdksJGULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQH5jOpHYwrGywOMQpwMCrx8D6Y
	xRwixJpYVlyZe4hRgoNZSYQ3NYMlRIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS
	1OzU1ILUIpgsEwenVANjFtuy9GvXZkdkrWqfxcQxfcsvq33CqgclJGYpSF+4kBgY6lhz7fJs
	Rz8N8cbJpixBjVeOnsrer6ve7hDwwkRko1KGoBdvhkmkfO5beyepneu2F224vlhKaB5j+VNr
	tlm7Z8kd/8CYZp/EfELqeprLAp5ExZp5fcy5RqYLmlj4qzzPsd9tCFZiKc5INNRiLipOBADy
	3bEoSAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ST SPEAR1340-MIPHY support should be available only on
ST SPEAr1340 machine.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Pratyush Anand <pratyush.anand@st.com>
Cc: Mohit Kumar <mohit.kumar@st.com>
---
 drivers/phy/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/phy/Kconfig
===================================================================
--- a/drivers/phy/Kconfig	2014-09-01 16:45:59.920734730 +0200
+++ b/drivers/phy/Kconfig	2014-09-01 16:47:12.588736649 +0200
@@ -221,6 +221,7 @@ config PHY_ST_SPEAR1310_MIPHY
 config PHY_ST_SPEAR1340_MIPHY
 	tristate "ST SPEAR1340-MIPHY driver"
 	select GENERIC_PHY
+	depends on MACH_SPEAR1340 || COMPILE_TEST
 	help
 	  Support for ST SPEAr1340 MIPHY which can be used for PCIe and SATA.
 

