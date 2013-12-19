Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab3LSWtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:49:13 -0500
Received: from mail-pb0-f74.google.com ([209.85.160.74]:53174 "EHLO
	mail-pb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab3LSWtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:49:11 -0500
From: Doug Anderson <dianders@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Simon Glass <sjg@chromium.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Olof Johansson <olof@lixom.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Ben Dooks <ben-linux@fluff.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ARM: dts: Add the missing "\" key in non-US keyboards for exynos5250-snow
Date: Thu, 19 Dec 2013 14:36:17 -0800
Message-Id: <1387492578-22068-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387492578-22068-1-git-send-email-dianders@chromium.org>
References: <1387492578-22068-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the exynos5250 device tree was sent upstream the keyboard mapping
was missing the 2nd instance of the "\" key.  There are two copies of
the "\" because it simply has a different row and column on US and
non-US keyboards.

For more details, see the previous patch in this series: (mkbp: Fix
problems with backslash).

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/boot/dts/exynos5250-snow.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index fd711e2..28fe2e2 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -130,6 +130,7 @@
 							0x04060024	/* J */
 							0x04080027	/* ; */
 							0x04090026	/* L */
+							0x040a002b	/* \ */
 							0x040b001c	/* ENTER */
 
 							0x0501002c	/* Z */
-- 
1.8.5.1

