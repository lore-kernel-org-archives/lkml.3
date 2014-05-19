Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbaESKKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:10:48 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:50800 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbaESKKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:10:14 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, joe@perches.com,
        auttamchandani@logicube.com, stern@rowland.harvard.edu
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 4/5] usb: gadget: net2280: Use true/false instead of 1/0
Date: Mon, 19 May 2014 12:10:04 +0200
Message-Id: <1400494205-26566-4-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.0.0.rc0
In-Reply-To: <1400494205-26566-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1400494205-26566-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For bool variables

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/net2280.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index 5b9368d..b43725a 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -95,9 +95,9 @@ static const char *const ep_name [] = {
  * Some gadget drivers work better with the dma support here than others.
  * These two parameters let you use PIO or more aggressive DMA.
  */
-static bool use_dma = 1;
-static bool use_dma_chaining = 0;
-static bool use_msi = 1;
+static bool use_dma = true;
+static bool use_dma_chaining;
+static bool use_msi = true;
 
 /* "modprobe net2280 use_dma=n" etc */
 module_param (use_dma, bool, S_IRUGO);
@@ -118,7 +118,7 @@ module_param (fifo_mode, ushort, 0644);
  * USB suspend requests will be ignored.  This is acceptable for
  * self-powered devices
  */
-static bool enable_suspend = 0;
+static bool enable_suspend;
 
 /* "modprobe net2280 enable_suspend=1" etc */
 module_param (enable_suspend, bool, S_IRUGO);
-- 
2.0.0.rc0

