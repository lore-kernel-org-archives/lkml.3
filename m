Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab3CLKOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:14:32 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13875 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab3CLKOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:14:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 12 Mar 2013 03:13:42 -0700
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
Subject: [RFC 06/17] mips: txx9: change GENERIC_GPIO to GPIOLIB
Date: Tue, 12 Mar 2013 19:12:19 +0900
Message-ID: <1363083150-30964-7-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO driver for txx9 requires gpiolib, so this is more accurate and
let us get rid of one mention of GENERIC_GPIO which is due to disappear.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/mips/txx9/generic/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/txx9/generic/setup.c b/arch/mips/txx9/generic/setup.c
index 5524f2c..5364aab 100644
--- a/arch/mips/txx9/generic/setup.c
+++ b/arch/mips/txx9/generic/setup.c
@@ -118,7 +118,7 @@ EXPORT_SYMBOL(clk_put);
 
 /* GPIO support */
 
-#ifdef CONFIG_GENERIC_GPIO
+#ifdef CONFIG_GPIOLIB
 int gpio_to_irq(unsigned gpio)
 {
 	return -EINVAL;
-- 
1.8.1.5

