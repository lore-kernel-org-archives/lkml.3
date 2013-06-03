Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336Ab3FCQOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:14:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36450 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758614Ab3FCQOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:14:20 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>, <balbi@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <kishon@ti.com>, <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <gregkh@linuxfoundation.org>,
        <benoit.cousson@linaro.org>, <anish198519851985@gmail.com>,
        <pmeerw@pmeerw.net>
Subject: [PATCH 2/5] extcon: Kconfig: Make extcon config type as bool
Date: Mon, 3 Jun 2013 21:43:37 +0530
Message-ID: <1370276020-17446-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370276020-17446-1-git-send-email-kishon@ti.com>
References: <1370276020-17446-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed the extcon config type to bool from module. Having extcon
config type as module leads to some "undefined reference to" errors
if the modules that uses these APIs are made as built-in and extcon
as module.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/extcon/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index 63f454e..ee9b7d4 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -1,5 +1,5 @@
 menuconfig EXTCON
-	tristate "External Connector Class (extcon) support"
+	bool "External Connector Class (extcon) support"
 	help
 	  Say Y here to enable external connector class (extcon) support.
 	  This allows monitoring external connectors by userspace
-- 
1.7.10.4

