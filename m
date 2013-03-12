Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab3CLKOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:14:09 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3984 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab3CLKOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:14:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 12 Mar 2013 03:13:49 -0700
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
Subject: [RFC 07/17] unicore32: remove unneeded select GENERIC_GPIO
Date: Tue, 12 Mar 2013 19:12:20 +0900
Message-ID: <1363083150-30964-8-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PUV3_GPIO depends on ARCH_PUV3 which requires GPIOLIB and thus already
selects GENERIC_GPIO

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/unicore32/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index dc50b15..a889117 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -219,7 +219,6 @@ if ARCH_PUV3
 config PUV3_GPIO
 	bool
 	depends on !ARCH_FPGA
-	select GENERIC_GPIO
 	select GPIO_SYSFS
 	default y
 
-- 
1.8.1.5

