Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3HMI5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 04:57:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:48082 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3HMI5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 04:57:13 -0400
Date: Tue, 13 Aug 2013 10:57:08 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Felipe Balbi <balbi@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH] usb: phy: am335x: include linux/err.h
Message-ID: <20130813085707.GB23842@linutronix.de>
References: <20130813181719.e2dea691c1e3c19bd6306983@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130813181719.e2dea691c1e3c19bd6306983@canb.auug.org.au>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell reported that this driver does not compile on PowerPC
due to this missing include. One could argue why this driver is enabled
on PowerPC in the first place but it sure isn't wrong to include headers
for used function instead of to rely that they sneak in.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/phy/phy-am335x-control.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/phy/phy-am335x-control.c b/drivers/usb/phy/phy-am335x-control.c
index 35494f1..7597545 100644
--- a/drivers/usb/phy/phy-am335x-control.c
+++ b/drivers/usb/phy/phy-am335x-control.c
@@ -1,5 +1,6 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/err.h>
 #include <linux/of.h>
 #include <linux/io.h>
 
-- 
1.8.4.rc1

