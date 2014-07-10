Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaGJLqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:46:09 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:35446 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbaGJLqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:46:07 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: comedi: vmk80xx: remove MODULE_VERSION() from in-kernel module
Date: Thu, 10 Jul 2014 12:45:43 +0100
Message-Id: <1404992744-3662-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404992744-3662-1-git-send-email-abbotti@mev.co.uk>
References: <1404992744-3662-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/vmk80xx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index 0adf3cf..831c3b7 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -959,5 +959,4 @@ module_comedi_usb_driver(vmk80xx_driver, vmk80xx_usb_driver);
 MODULE_AUTHOR("Manuel Gebele <forensixs@gmx.de>");
 MODULE_DESCRIPTION("Velleman USB Board Low-Level Driver");
 MODULE_SUPPORTED_DEVICE("K8055/K8061 aka VM110/VM140");
-MODULE_VERSION("0.8.01");
 MODULE_LICENSE("GPL");
-- 
2.0.0

