Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab3GHIZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 04:25:42 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:54757 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464Ab3GHIZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 04:25:37 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH v1 2/4] ARM: STi: Set correct ARM ERRATAs.
Date: Mon,  8 Jul 2013 09:18:06 +0100
Message-Id: <1373271486-11631-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1373271301-11060-1-git-send-email-srinivas.kandagatla@st.com>
References: <1373271301-11060-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Some of the ARM_ERRATA selection is not done in the initial SOC support
patches. This patch selects 2 new ARM_ERRATA's and removes one which was
actually fixed.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 arch/arm/mach-sti/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-sti/Kconfig b/arch/arm/mach-sti/Kconfig
index d04e3bf..c216094 100644
--- a/arch/arm/mach-sti/Kconfig
+++ b/arch/arm/mach-sti/Kconfig
@@ -11,8 +11,9 @@ menuconfig ARCH_STI
 	select HAVE_SMP
 	select HAVE_ARM_SCU if SMP
 	select ARCH_REQUIRE_GPIOLIB
-	select ARM_ERRATA_720789
 	select ARM_ERRATA_754322
+	select ARM_ERRATA_775420
+	select ARM_ERRATA_764369
 	select PL310_ERRATA_753970 if CACHE_PL310
 	select PL310_ERRATA_769419 if CACHE_PL310
 	help
-- 
1.7.6.5

