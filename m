Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab3HZPzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:55:47 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:43535 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab3HZPzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:55:45 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Bo Shen <voice.shen@atmel.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: soc update for 3.12 #1
Date: Mon, 26 Aug 2013 17:55:43 +0200
Message-ID: <1377532543-349-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

Here is AT91 SoC updates for 3.12 kernel. It is the first pull-request for
this topic and it is based on 3.11-rc5 like your next/soc branch.

Thanks, best regards,

The following changes since commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:

  Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-soc

for you to fetch changes up to 99eb3b40ec42e7fce1fc58429bf9b26c17973c12:

  ARM: at91: at91_dt_defconfig: enable rm9200 support (2013-08-26 09:58:29 +0200)

----------------------------------------------------------------
AT91 SoC update for 3.12 take 1
- enable kernel uncompress information output for
  SoC where it was missing: at91sam9n12 and sama5d3
- addition of at91rm9200 to the generic at91_dt_defconfig

----------------------------------------------------------------
Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: at91_dt_defconfig: enable rm9200 support

voice (4):
      ARM: at91: sama5d3: add definition for usart base address
      ARM: at91: include sama5d3.h into hardware.h
      ARM: at91: sama5: enable kernel uncompress info output
      ARM: at91: sam9n12: enable kernel uncompress info output

 arch/arm/configs/at91_dt_defconfig           |  4 +++-
 arch/arm/mach-at91/include/mach/hardware.h   |  1 +
 arch/arm/mach-at91/include/mach/sama5d3.h    |  8 ++++++++
 arch/arm/mach-at91/include/mach/uncompress.h | 13 +++++++++++++
 4 files changed, 25 insertions(+), 1 deletion(-)

-- 
Nicolas Ferre
