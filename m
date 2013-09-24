Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3IXNB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 09:01:26 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:36805 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3IXNBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 09:01:25 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: fixes for 3.12 #1
Date: Tue, 24 Sep 2013 15:01:22 +0200
Message-ID: <1380027682-8132-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This is the first batch of fixes for AT91.
I think that the removal of the void flag IRQF_DISABLED can be schedulled in
this timeframe as we are pretty early in the cycle and that this patch
shouldn't wait more.

Thanks, best regards,

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to 9ceb389dddbcdb87830f01fcf84d94b2da581dae:

  ARM: at91: remove IRQF_DISABLED (2013-09-19 15:36:35 +0200)

----------------------------------------------------------------
First fixes series for 3.12
- removal of void IRQF_DISABLED flag in timer drivers
- two little fixes in DT for at91sam9x5 family

----------------------------------------------------------------
Jiri Prchal (1):
      ARM: at91: serial: fix wrong pinctrl_usart2_rts

Michael Opdenacker (1):
      ARM: at91: remove IRQF_DISABLED

Nicolas Ferre (1):
      ARM: at91: at91sam9x5: set default mmc[01] pinctrl-names

 arch/arm/boot/dts/at91sam9x5.dtsi     | 6 ++++--
 arch/arm/mach-at91/at91rm9200_time.c  | 2 +-
 arch/arm/mach-at91/at91sam926x_time.c | 2 +-
 arch/arm/mach-at91/at91x40_time.c     | 2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

-- 
Nicolas Ferre
