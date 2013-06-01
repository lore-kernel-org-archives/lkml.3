Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab3FAKLX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 06:11:23 -0400
Received: from www17.your-server.de ([213.133.104.17]:34776 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3FAKLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 06:11:14 -0400
Message-ID: <1370081459.29224.44.camel@localhost.localdomain>
Subject: [PATCH] usb: dwc3: core: Cocci spatch "odd_ptr_err.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: balbi@ti.com, grant.likely@linaro.org, rob.herring@calxeda.com,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 12:10:59 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -450,7 +450,7 @@ static int dwc3_probe(struct platform_de
 	}
 
 	if (IS_ERR(dwc->usb3_phy)) {
-		ret = PTR_ERR(dwc->usb2_phy);
+		ret = PTR_ERR(dwc->usb3_phy);
 
 		/*
 		 * if -ENXIO is returned, it means PHY layer wasn't



