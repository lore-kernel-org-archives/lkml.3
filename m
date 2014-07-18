Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934272AbaGRJcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:32:11 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:56585 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760988AbaGRJcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:32:05 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 2/9] usb: phy: am335x: group the #includes by subdirs
Date: Fri, 18 Jul 2014 11:31:23 +0200
Message-Id: <1405675890-8802-3-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/usb/phy/phy-am335x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/phy/phy-am335x.c b/drivers/usb/phy/phy-am335x.c
index b70e055..91c71ab 100644
--- a/drivers/usb/phy/phy-am335x.c
+++ b/drivers/usb/phy/phy-am335x.c
@@ -1,13 +1,13 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
-#include <linux/usb/otg.h>
-#include <linux/usb/usb_phy_generic.h>
 #include <linux/slab.h>
 #include <linux/clk.h>
-#include <linux/regulator/consumer.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/regulator/consumer.h>
+#include <linux/usb/otg.h>
+#include <linux/usb/usb_phy_generic.h>
 
 #include "am35x-phy-control.h"
 #include "phy-generic.h"
-- 
1.7.10.4

