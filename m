Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbaIINS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:18:56 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:42667 "EHLO
	mail.work-microwave.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388AbaIINSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:18:54 -0400
From: Roland Stigge <stigge@antcom.de>
To: broonie@kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] SPI: Fix error message
Date: Tue,  9 Sep 2014 15:17:50 +0200
Message-Id: <1410268670-7132-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 2.1.0
X-FEAS-SYSTEM-WL: "Roland Stigge" <stigge@antcom.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an error message typo ("not" missing).

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 drivers/spi/spi-pl022.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -2136,7 +2136,7 @@ static int pl022_probe(struct amba_devic
 						cs_gpio);
 				else if (gpio_direction_output(cs_gpio, 1))
 					dev_err(&adev->dev,
-						"could set gpio %d as output\n",
+						"could not set gpio %d as output\n",
 						cs_gpio);
 			}
 		}
