Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab3AKNPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:15:09 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:54306 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab3AKNNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:13:50 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        Marcus Cooper <marcus.xm.cooper@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 15/18] power: ab8500_charger: remove unused defines.
Date: Fri, 11 Jan 2013 13:13:03 +0000
Message-Id: <1357909986-9262-16-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
References: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Cooper <marcus.xm.cooper@stericsson.com>

Cleanup of the ab8500_charger driver.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
---
 drivers/power/ab8500_charger.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 30193ea..2769e91 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -115,11 +115,6 @@ enum ab8500_charger_link_status {
 	USB_STAT_CARKIT_1,
 	USB_STAT_CARKIT_2,
 	USB_STAT_ACA_DOCK_CHARGER,
-	USB_STAT_SAMSUNG_USB_PHY_DIS,
-	USB_STAT_SAMSUNG_USB_PHY_ENA,
-	USB_STAT_SAMSUNG_UART_PHY_DIS,
-	USB_STAT_SAMSUNG_UART_PHY_ENA,
-	USB_STAT_MOTOROLA_USB_PHY_ENA,
 };
 
 enum ab8500_usb_state {
-- 
1.7.9.5

