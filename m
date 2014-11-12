Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaKLBLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:11:24 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:63240 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbaKLBKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:10:17 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] staging: panel: Reorder initial DEFAULT_* defines
Date: Wed, 12 Nov 2014 02:08:06 +0100
Message-Id: <1415754489-9097-2-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415754489-9097-1-git-send-email-marius.gorski@gmail.com>
References: <1415754489-9097-1-git-send-email-marius.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the order of the initial DEFAULT_* defines so that it
matches the Kconfig order.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
---
 drivers/staging/panel/panel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index d30ccb5..530f7e1 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -302,14 +302,15 @@ static unsigned char lcd_bits[LCD_PORTS][LCD_BITS][BIT_STATES];
 /*
  * Construct custom config from the kernel's configuration
  */
-#define DEFAULT_PROFILE         PANEL_PROFILE_LARGE
 #define DEFAULT_PARPORT         0
-#define DEFAULT_LCD             LCD_TYPE_OLD
+#define DEFAULT_PROFILE         PANEL_PROFILE_LARGE
 #define DEFAULT_KEYPAD          KEYPAD_TYPE_OLD
+#define DEFAULT_LCD             LCD_TYPE_OLD
+#define DEFAULT_LCD_HEIGHT      2
 #define DEFAULT_LCD_WIDTH       40
 #define DEFAULT_LCD_BWIDTH      40
 #define DEFAULT_LCD_HWIDTH      64
-#define DEFAULT_LCD_HEIGHT      2
+#define DEFAULT_LCD_CHARSET     LCD_CHARSET_NORMAL
 #define DEFAULT_LCD_PROTO       LCD_PROTO_PARALLEL
 
 #define DEFAULT_LCD_PIN_E       PIN_AUTOLF
@@ -318,7 +319,6 @@ static unsigned char lcd_bits[LCD_PORTS][LCD_BITS][BIT_STATES];
 #define DEFAULT_LCD_PIN_SCL     PIN_STROBE
 #define DEFAULT_LCD_PIN_SDA     PIN_D0
 #define DEFAULT_LCD_PIN_BL      PIN_NOT_SET
-#define DEFAULT_LCD_CHARSET     LCD_CHARSET_NORMAL
 
 #ifdef CONFIG_PANEL_PROFILE
 #undef DEFAULT_PROFILE
-- 
2.1.3

