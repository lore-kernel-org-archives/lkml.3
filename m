Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab3AQJJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:09:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50402 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab3AQJJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:09:37 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Viresh Kumar <viresh.linux@gmail.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ARM: spear3xx: Fix pl080-related build failure
Date: Thu, 17 Jan 2013 10:09:23 +0100
Message-Id: <1358413763-21507-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
X-Provags-ID: V02:K0:I2wMVz97+xiwzducdS+fILl+fIU+8DCmvUvVi0jP+vi
 vHpBLAgWsJT6oGsJyiJkfWkKXJynCuV3c7Q2ur37VNUkKpR052
 2vd1LoKK565f9ofE+iaZqGoW84R7mJvsxqNaDIE3UWJJWK1KIo
 +1ZDYV0DgZ9T5A/i2n9wo22sJejHNt9ko1f/g6wY8JROwDTjyT
 gPl70+mfb6qbckYH4UxM8OoTaBxWN9Ol3/Kt/qcuYlxn/3I3cL
 5zqamw3y3Q6niM289MLZkrpWu7gJquaaDVCBCD5IbeOqrCGa2e
 9nUPwLHX9KRHj1GsCULuwjtpNWWgPHD5cn5LtmAcOGlDaQDan6
 qKbIIowTuSquKfpwPdirwvOUixc4gDWmC8Z1D7L1xRBBVtieeP
 v8+WbTBvEHpv+DGumdd9VuaM6KLOiwm7BtA8mqABd/hahOUM0p
 3i6je
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/amba/pl080.h to pull in the various PL080_* macros.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/mach-spear3xx/spear3xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-spear3xx/spear3xx.c b/arch/arm/mach-spear3xx/spear3xx.c
index f9d754f..7c218d9 100644
--- a/arch/arm/mach-spear3xx/spear3xx.c
+++ b/arch/arm/mach-spear3xx/spear3xx.c
@@ -14,6 +14,7 @@
 #define pr_fmt(fmt) "SPEAr3xx: " fmt
 
 #include <linux/amba/pl022.h>
+#include <linux/amba/pl080.h>
 #include <linux/amba/pl08x.h>
 #include <linux/io.h>
 #include <plat/pl080.h>
-- 
1.8.1.1

