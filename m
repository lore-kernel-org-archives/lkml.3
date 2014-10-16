Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaJPPxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 11:53:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39795 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751196AbaJPPxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 11:53:02 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] USB: OHCI: ohci-at91: remove unnecessary headers
Date: Thu, 16 Oct 2014 17:52:38 +0200
Message-Id: <1413474758-18861-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary mach/* headers to be able to converge to a multiplatform
kernel.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/usb/host/ohci-at91.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index e49eb4f90f5d..6181549883af 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -24,12 +24,8 @@
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
 
-#include <mach/hardware.h>
 #include <asm/gpio.h>
 
-#include <mach/cpu.h>
-
-
 #include "ohci.h"
 
 #define valid_port(index)	((index) >= 0 && (index) < AT91_MAX_USBH_PORTS)
-- 
1.9.1

