Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab3CLKNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:13:48 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3900 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab3CLKNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:13:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 12 Mar 2013 03:13:29 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, Paul Mundt <lethal@linux-sh.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>
CC: Alexandre Courbot <gnurou@gmail.com>, <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 04/17] mips: remove redundant GENERIC_GPIO select
Date: Tue, 12 Mar 2013 19:12:17 +0900
Message-ID: <1363083150-30964-5-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/mips/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index b7b7228..ae70ab1 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1199,7 +1199,6 @@ config CPU_LOONGSON2F
 	bool "Loongson 2F"
 	depends on SYS_HAS_CPU_LOONGSON2F
 	select CPU_LOONGSON2
-	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
 	help
 	  The Loongson 2F processor implements the MIPS III instruction set
-- 
1.8.1.5

