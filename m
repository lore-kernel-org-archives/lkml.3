Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3CEJNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 04:13:47 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:61954 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753536Ab3CEJNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 04:13:45 -0500
Message-ID: <1362474819.16460.63.camel@x61.thuisdomein>
Subject: [PATCH] ARM: SPEAr13xx: Fix typo "ARCH_HAVE_CPUFREQ"
From: Paul Bolle <pebolle@tiscali.nl>
To: Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Mar 2013 10:13:39 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2013 09:13:39.0775 (UTC) FILETIME=[B9B9A4F0:01CE1981]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do what commit f12a500e4adcc0961803e54b5ed1e74275d399f1
("ARM: SPEAr13xx: Enable CONFIG_ARCH_HAS_CPUFREQ") wanted to do.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/arm/plat-spear/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/plat-spear/Kconfig b/arch/arm/plat-spear/Kconfig
index 739d016..8a08c31 100644
--- a/arch/arm/plat-spear/Kconfig
+++ b/arch/arm/plat-spear/Kconfig
@@ -10,7 +10,7 @@ choice
 
 config ARCH_SPEAR13XX
 	bool "ST SPEAr13xx with Device Tree"
-	select ARCH_HAVE_CPUFREQ
+	select ARCH_HAS_CPUFREQ
 	select ARM_GIC
 	select CPU_V7
 	select GPIO_SPEAR_SPICS
-- 
1.7.11.7



