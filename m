Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbaCQNId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:08:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58843 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933185AbaCQNI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:08:29 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-0f-5326f3cc1de6
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Oliver Schinagl <oliver@schinagl.nl>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ata: ahci_sunxi: fix code formatting
Date: Mon, 17 Mar 2014 14:08:12 +0100
Message-id: <10509185.3UEOEZKTc5@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jQd0zn9WCDY581LV4c3w6k8Wmx9dY
	LY7teMRkcXnXHDaLrZv2Mlu8nPSQ1eLX8qOMDuweTzZdZPTYtKqTzWPzknqP9/uusnm0tixn
	9fi8SS6ALYrLJiU1J7MstUjfLoEr49HP52wFH/gqFr/6yt7A+IWni5GTQ0LARGLKyi/sELaY
	xIV769m6GLk4hASmM0p8OHOIFcJpYZJY9P0DG0gVm4CVxMT2VYwgtoiArMSVaQ8ZQYqYBZ4w
	Siw4uRWsSFjAVKLx0yawIhYBVYktH9+AreAV0JK4+mcBC4gtKuApsWP7SjaIuKDEj8n3wOLM
	AvIS+/ZPZYWwtSTW7zzONIGRbxaSsllIymYhKVvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85
	P3cTIziAn0nvYFzVYHGIUYCDUYmHd4KyWrAQa2JZcWXuIUYJDmYlEV6nd0Ah3pTEyqrUovz4
	otKc1OJDjNIcLErivAdbrQOFBNITS1KzU1MLUotgskwcnFINjC4uS5Orvlx4cbqgZIuElvne
	2+vn7eMy6Ptekbs3eZKo5c+CIttXTI6PO3rKNzbPOMqQkMskpP939Z/l7v1TvvucD4qZrG7b
	c2/BAQ8Ti8abc+6lGez8vfBS9vwvIo/yE22aFi6QdjA/viiCx/eeQ7H+q23Zv+OYmVv2iGjl
	HZlvXFRXx5YQp8RSnJFoqMVcVJwIAB72wdpcAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/ata/ahci_sunxi.c |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

Index: b/drivers/ata/ahci_sunxi.c
===================================================================
--- a/drivers/ata/ahci_sunxi.c	2014-03-17 13:59:06.220474478 +0100
+++ b/drivers/ata/ahci_sunxi.c	2014-03-17 14:00:48.720472730 +0100
@@ -27,28 +27,28 @@
 #include <linux/regulator/consumer.h>
 #include "ahci.h"
 
-#define AHCI_BISTAFR 0x00a0
-#define AHCI_BISTCR 0x00a4
-#define AHCI_BISTFCTR 0x00a8
-#define AHCI_BISTSR 0x00ac
-#define AHCI_BISTDECR 0x00b0
-#define AHCI_DIAGNR0 0x00b4
-#define AHCI_DIAGNR1 0x00b8
-#define AHCI_OOBR 0x00bc
-#define AHCI_PHYCS0R 0x00c0
-#define AHCI_PHYCS1R 0x00c4
-#define AHCI_PHYCS2R 0x00c8
-#define AHCI_TIMER1MS 0x00e0
-#define AHCI_GPARAM1R 0x00e8
-#define AHCI_GPARAM2R 0x00ec
-#define AHCI_PPARAMR 0x00f0
-#define AHCI_TESTR 0x00f4
-#define AHCI_VERSIONR 0x00f8
-#define AHCI_IDR 0x00fc
-#define AHCI_RWCR 0x00fc
-#define AHCI_P0DMACR 0x0170
-#define AHCI_P0PHYCR 0x0178
-#define AHCI_P0PHYSR 0x017c
+#define AHCI_BISTAFR	0x00a0
+#define AHCI_BISTCR	0x00a4
+#define AHCI_BISTFCTR	0x00a8
+#define AHCI_BISTSR	0x00ac
+#define AHCI_BISTDECR	0x00b0
+#define AHCI_DIAGNR0	0x00b4
+#define AHCI_DIAGNR1	0x00b8
+#define AHCI_OOBR	0x00bc
+#define AHCI_PHYCS0R	0x00c0
+#define AHCI_PHYCS1R	0x00c4
+#define AHCI_PHYCS2R	0x00c8
+#define AHCI_TIMER1MS	0x00e0
+#define AHCI_GPARAM1R	0x00e8
+#define AHCI_GPARAM2R	0x00ec
+#define AHCI_PPARAMR	0x00f0
+#define AHCI_TESTR	0x00f4
+#define AHCI_VERSIONR	0x00f8
+#define AHCI_IDR	0x00fc
+#define AHCI_RWCR	0x00fc
+#define AHCI_P0DMACR	0x0170
+#define AHCI_P0PHYCR	0x0178
+#define AHCI_P0PHYSR	0x017c
 
 static void sunxi_clrbits(void __iomem *reg, u32 clr_val)
 {

