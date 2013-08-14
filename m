Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530Ab3HNIdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 04:33:38 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:56166 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab3HNIdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 04:33:36 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: <b.brezillon@overkiz.com>, <dgilbert@interlog.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: fixes for 3.11 #1
Date: Wed, 14 Aug 2013 10:33:33 +0200
Message-ID: <1376469213-30981-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This is the first (late) fixes pull-reqest for AT91. I would understand if
you refuse it because we are already at -rc5 ;-) ...

On the other hand, the line count is very low and all patches are pretty
obvious.

Thanks, best regards,

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to a57603ca2871ee0773b00839c1ea35c4a2d3eeb0:

  ARM: at91/DT: fix at91sam9n12ek memory node (2013-08-14 09:56:31 +0200)

----------------------------------------------------------------
Device tree related fixes:
- USB host numbering for 9x5 which was preventing from using all ports
- a missing UART (not USART) clock lookup table was preventing from using
  them on 9x5
- too large amount of memory was specified for 9n12ek

----------------------------------------------------------------
Boris BREZILLON (1):
      ARM: at91: add missing uart clocks DT entries

Nicolas Ferre (2):
      ARM: at91/DT: at91sam9x5ek: fix USB host property to enable port C
      ARM: at91/DT: fix at91sam9n12ek memory node

 arch/arm/boot/dts/at91sam9n12ek.dts | 4 ++--
 arch/arm/boot/dts/at91sam9x5ek.dtsi | 5 +++--
 arch/arm/mach-at91/at91sam9x5.c     | 2 ++
 3 files changed, 7 insertions(+), 4 deletions(-)

-- 
Nicolas Ferre
