Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab3DSG3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 02:29:05 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33901 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330Ab3DSG2u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 02:28:50 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] backlight: lp855x: fix initial brightness type
Thread-Topic: [PATCH 3/5] backlight: lp855x: fix initial brightness type
Thread-Index: Ac48xx4uUwGHeXH2QKmqQERaO6MnbQ==
Date: Fri, 19 Apr 2013 06:28:34 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E562AE@DQHE06.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valid range of the brightness is from 0 to 255, so initial brightness
is changed from integer to u8.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 include/linux/platform_data/lp855x.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/platform_data/lp855x.h b/include/linux/platform_data/lp855x.h
index e0954df..a4ed0bd 100644
--- a/include/linux/platform_data/lp855x.h
+++ b/include/linux/platform_data/lp855x.h
@@ -124,7 +124,7 @@ struct lp855x_rom_data {
 struct lp855x_platform_data {
 	const char *name;
 	u8 device_control;
-	int initial_brightness;
+	u8 initial_brightness;
 	unsigned int period_ns;
 	u8 load_new_rom_data;
 	int size_program;
-- 
1.7.9.5


Best Regards,
Milo


