Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372Ab3AQI3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 03:29:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:55926 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759236Ab3AQI3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 03:29:15 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Viresh Kumar <viresh.linux@gmail.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: spear3xx: Fix pl080-related build failure
Date: Thu, 17 Jan 2013 09:29:11 +0100
Message-Id: <1358411351-18506-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
X-Provags-ID: V02:K0:H5i9HaDT8Cr/JLJsAZgctlCAtbbt8MeOSR96U3wsEfz
 2HamczGCJ1B5Oc41LdVb7BDrv9nQwQZ/juKkc3eNTP0FIKFkbw
 UopQvaTMpL+oxo+ZLP9GOQG2oNwaYrr8SvB7a2LTairGKbC6Dj
 H45JH8eh4E0kd7Agw0f1T95ovDPpQ+K0Mg/Tb+R3ruHwt2bur8
 t4z8keU5h+3GooPRiG8em/gKxA0A2izeXUykDicf69ikZblqlr
 npeFvQtsUuojM+u6ybv1OBa8vA3u6bRX7xaqPJ476ZJMY3hoFO
 237sHYchnMS1P3Kp/X66ad3arU/KzlQDX66Qw7Aky4vLAlMEp8
 z/jF74N0WscwPq23OVecjfOE4/p61iFqSJS9m9iyfizALmD/Kz
 Y8vmvygpGcObpVMctAfpmJlmcA5BCRAaE6k2wJSf0nyIi2NOks
 zJwhR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/amba/pl08x.h to pull in the various PL080_* macros.

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

