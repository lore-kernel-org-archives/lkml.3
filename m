Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbaIIKoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:44:46 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:38738 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755955AbaIIK05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:26:57 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Ungerer <gerg@uclinux.org>, Ryan Mallon <rmallon@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Wolfram Sang <wsa@sang-engineering.com>,
        Andrew Victor <linux@maxim.org.za>, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        linux-omap@vger.kernel.org, Ulrich Hecht <ulrich.hecht@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Simon Horman <horms+renesas@verge.net.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 0/3] kbuild: Clean up makefiles and then drop obj-n an obj-n
Date: Tue,  9 Sep 2014 19:26:18 +0900
Message-Id: <1410258381-7088-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Masahiro Yamada (3):
  kbuild: remove unnecessary "obj- := dummy.o" trick
  kbuild: remove unnecessary variable initializaions
  kbuild: remove obj-n and lib-n handling

 arch/arm/mach-at91/Makefile       | 3 ---
 arch/arm/mach-ebsa110/Makefile    | 3 ---
 arch/arm/mach-ep93xx/Makefile     | 3 ---
 arch/arm/mach-exynos/Makefile     | 5 -----
 arch/arm/mach-footbridge/Makefile | 3 ---
 arch/arm/mach-iop13xx/Makefile    | 5 -----
 arch/arm/mach-iop32x/Makefile     | 3 ---
 arch/arm/mach-iop33x/Makefile     | 3 ---
 arch/arm/mach-ks8695/Makefile     | 3 ---
 arch/arm/mach-rpc/Makefile        | 4 ----
 arch/arm/mach-s3c24xx/Makefile    | 5 -----
 arch/arm/mach-s3c64xx/Makefile    | 5 -----
 arch/arm/mach-s5pv210/Makefile    | 5 -----
 arch/arm/mach-sa1100/Makefile     | 3 ---
 arch/arm/mach-u300/Makefile       | 3 ---
 arch/arm/plat-iop/Makefile        | 6 ------
 arch/arm/plat-omap/Makefile       | 3 ---
 arch/arm/plat-samsung/Makefile    | 5 -----
 drivers/clk/shmobile/Makefile     | 2 --
 drivers/net/wimax/Makefile        | 4 ----
 firmware/Makefile                 | 2 +-
 scripts/Makefile.build            | 4 ++--
 scripts/Makefile.clean            | 4 +---
 scripts/Makefile.fwinst           | 2 +-
 24 files changed, 5 insertions(+), 83 deletions(-)

-- 
1.9.1

