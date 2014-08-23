Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaHWAJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 20:09:27 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:34200 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbaHWAJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 20:09:25 -0400
From: Michal Sojka <sojka@merica.cz>
To: linux-usb@vger.kernel.org
Cc: Michal Sojka <sojka@merica.cz>, Bryan Wu <cooloney@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-kernel@vger.kernel.org, michal.vokac@comap.cz
Subject: [PATCH v2 1/3] usb: Add missing #include
Date: Sat, 23 Aug 2014 02:08:20 +0200
Message-Id: <1408752502-4162-2-git-send-email-sojka@merica.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408752502-4162-1-git-send-email-sojka@merica.cz>
References: <87ha149j2z.fsf@steelpick.2x.cz>
 <1408752502-4162-1-git-send-email-sojka@merica.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/usb/hcd.h needs the definition of struct usb_bus.

Signed-off-by: Michal Sojka <sojka@merica.cz>
---
 include/linux/usb/hcd.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 485cd5e..b43f0fe 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -23,6 +23,7 @@
 
 #include <linux/rwsem.h>
 #include <linux/interrupt.h>
+#include <linux/usb.h>
 
 #define MAX_TOPO_LEVEL		6
 
-- 
2.1.0

