Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaL2ObS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:31:18 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:14761 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752350AbaL2ObK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:31:10 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am0QAHdloVRXQ5FV/2dsb2JhbABcgwaBKrQrAQEBAQEBBQF3lzAEAgKBCxcBAQEBAX2EDQEFViMQUTkeGYgwAbQmjxMBAQEHIoYDiXQHFoQTBYw+ikqRUCKDbz0xgkMBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 04/11 linux-next] input: remove unnecessary version.h inclusion
Date: Mon, 29 Dec 2014 15:29:38 +0100
Message-Id: <1419863387-24233-5-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419863387-24233-1-git-send-email-fabf@skynet.be>
References: <1419863387-24233-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on versioncheck.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/input/touchscreen/elants_i2c.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/input/touchscreen/elants_i2c.c b/drivers/input/touchscreen/elants_i2c.c
index a510f7e..926c58e 100644
--- a/drivers/input/touchscreen/elants_i2c.c
+++ b/drivers/input/touchscreen/elants_i2c.c
@@ -33,10 +33,8 @@
 #include <linux/delay.h>
 #include <linux/uaccess.h>
 #include <linux/buffer_head.h>
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <linux/firmware.h>
-#include <linux/version.h>
 #include <linux/input/mt.h>
 #include <linux/acpi.h>
 #include <linux/of.h>
-- 
2.1.0

