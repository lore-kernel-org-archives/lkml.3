Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab3HWLNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:13:13 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:54787 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab3HWLNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:13:12 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sachin.kamat@linaro.org
Subject: [PATCH 1/1] mfd: omap-usb-host: Staticize usbhs_driver_name
Date: Fri, 23 Aug 2013 16:42:58 +0530
Message-Id: <1377256378-13677-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usbhs_driver_name is used only in this file. Make it static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/omap-usb-host.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index d2b8e71..29ee54d 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -114,7 +114,7 @@ struct usbhs_hcd_omap {
 };
 /*-------------------------------------------------------------------------*/
 
-const char usbhs_driver_name[] = USBHS_DRIVER_NAME;
+static const char usbhs_driver_name[] = USBHS_DRIVER_NAME;
 static u64 usbhs_dmamask = DMA_BIT_MASK(32);
 
 /*-------------------------------------------------------------------------*/
-- 
1.7.4.1

