Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaBMEXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 23:23:10 -0500
Received: from m12-12.163.com ([220.181.12.12]:45888 "EHLO m12-12.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbaBMEXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 23:23:08 -0500
From: liujunliang_ljl@163.com
To: thierry.reding@gmail.com
Cc: davem@davemloft.net, horms@verge.net.au, joe@perches.com,
        romieu@fr.zoreil.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, sunhecheng@vip.126.com,
        Liu Junliang <liujunliang_ljl@163.com>
Subject: [PATCH] Fix Default to 'y' for SR9800 Device Driver, setting to 'n'
Date: Thu, 13 Feb 2014 12:22:19 +0800
Message-Id: <1392265339-14841-1-git-send-email-liujunliang_ljl@163.com>
X-Mailer: git-send-email 1.7.9.5
X-CM-TRANSID: DMCowEBZx0mESPxSdRgIAw--.100S2
X-Coremail-Antispam: 1Uf129KBjvdXoW5KrW5urWkJw4DGr4rJF47urg_yoWxWrc_GF
	nrWF4xCF4FyasFgr4rGr4rZr17t3WkXan5Aa4Sy39xZw17XF9Fgw1kZF48twnrW3yUuF9x
	W3s2vF4Sy340qjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUivttUUUUU==
X-Originating-IP: [113.110.151.25]
X-CM-SenderInfo: xolxy3pqolt0hjboyzi6rwjhhfrp/1tbiHQMxX1EAJXpYqAAAsO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Junliang <liujunliang_ljl@163.com>


Signed-off-by: Liu Junliang <liujunliang_ljl@163.com>
---
 drivers/net/usb/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 2551bf6..82df7c3 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -295,7 +295,6 @@ config USB_NET_SR9800
 	tristate "CoreChip-sz SR9800 based USB 2.0 10/100 ethernet devices"
 	depends on USB_USBNET
 	select CRC32
-	default y
 	---help---
 	  Say Y if you want to use one of the following 100Mbps USB Ethernet
 	  device based on the CoreChip-sz SR9800 chip.
-- 
1.7.9.5


