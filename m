Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab3LLN2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:28:21 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:33492 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3LLN00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:26:26 -0500
From: Matt Porter <mporter@linaro.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>
Cc: Tomasz Figa <t.figa@samsung.com>, Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH v5 4/9] usb: gadget: s3c-hsotg: add snps,dwc2 compatible string
Date: Thu, 12 Dec 2013 08:26:05 -0500
Message-Id: <1386854770-2173-5-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386854770-2173-1-git-send-email-mporter@linaro.org>
References: <1386854770-2173-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable support for the dwc2 binding.

Signed-off-by: Matt Porter <mporter@linaro.org>
---
 drivers/usb/gadget/s3c-hsotg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 8ceb5ef..7c5d8bd 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -3727,6 +3727,7 @@ static int s3c_hsotg_remove(struct platform_device *pdev)
 #ifdef CONFIG_OF
 static const struct of_device_id s3c_hsotg_of_ids[] = {
 	{ .compatible = "samsung,s3c6400-hsotg", },
+	{ .compatible = "snps,dwc2", },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, s3c_hsotg_of_ids);
-- 
1.8.4

