Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab3G2SiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:38:18 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:32851 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560Ab3G2SiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:38:12 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 1/3] gpio: pcf857x: Sort headers alphabetically
Date: Mon, 29 Jul 2013 20:39:03 +0200
Message-Id: <1375123145-31648-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1375123145-31648-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1375123145-31648-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes checking for duplicates when adding a new #include easier.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpio/gpio-pcf857x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
index e8faf53..ea9f3580 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -18,15 +18,15 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/kernel.h>
-#include <linux/slab.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pcf857x.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 
-- 
1.8.1.5

