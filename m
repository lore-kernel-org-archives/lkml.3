Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaBISvq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:51:46 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62421 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaBISsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:38 -0500
From: Richard Weinberger <richard@nod.at>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRA...),
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 19/28] Remove SI4713
Date: Sun,  9 Feb 2014 19:47:57 +0100
Message-Id: <1391971686-9517-20-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/media/radio/si4713/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/radio/si4713/Kconfig b/drivers/media/radio/si4713/Kconfig
index a7c3ba8..ed51ed0 100644
--- a/drivers/media/radio/si4713/Kconfig
+++ b/drivers/media/radio/si4713/Kconfig
@@ -1,7 +1,6 @@
 config USB_SI4713
 	tristate "Silicon Labs Si4713 FM Radio Transmitter support with USB"
 	depends on USB && RADIO_SI4713
-	select SI4713
 	---help---
 	  This is a driver for USB devices with the Silicon Labs SI4713
 	  chip. Currently these devices are known to work.
@@ -16,7 +15,6 @@ config USB_SI4713
 config PLATFORM_SI4713
 	tristate "Silicon Labs Si4713 FM Radio Transmitter support with I2C"
 	depends on I2C && RADIO_SI4713
-	select SI4713
 	---help---
 	  This is a driver for I2C devices with the Silicon Labs SI4713
 	  chip.
-- 
1.8.4.2

