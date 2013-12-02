Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab3LBNis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:38:48 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:46319 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab3LBNio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:38:44 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, <arm@kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>, <motobud@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [GIT PULL] at91: fixes 3.13 #2
Date: Mon, 2 Dec 2013 14:38:41 +0100
Message-ID: <1385991521-3934-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

A second round of fixes for 3.13 on top of 3.13-rc1. The main fix of this
series is the one that reduces the frequency of the i2c IP and avoid to hit
some nasty hardware bugs. It actually allows to save a little power as well...

Thanks, best regards,

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to 7093bf2b7195541281cb711e31c027a8d826c6df:

  ARM: at91: fixed unresolved symbol "at91_pm_set_standby" when built without CONFIG_PM (2013-12-02 14:24:40 +0100)

----------------------------------------------------------------
AT91: second round of fixes for 3.13
- reduce IP frequency for I2C on sama5d3
- missing aliases directive for USART3 on 9x5 family
- a PM symbol is missing if !CONFIG_PM

----------------------------------------------------------------
Brent Taylor (1):
      ARM: at91: fixed unresolved symbol "at91_pm_set_standby" when built without CONFIG_PM

Ludovic Desroches (1):
      ARM: at91: sama5d3: reduce TWI internal clock frequency

Nicolas Ferre (1):
      ARM: at91: add usart3 alias to dtsi

 arch/arm/boot/dts/at91sam9x5_usart3.dtsi | 4 ++++
 arch/arm/mach-at91/pm.h                  | 4 ++++
 arch/arm/mach-at91/sama5d3.c             | 6 +++---
 3 files changed, 11 insertions(+), 3 deletions(-)

-- 
Nicolas Ferre
