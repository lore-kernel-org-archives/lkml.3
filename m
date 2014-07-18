Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030787AbaGROMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:12:15 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:36196 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030732AbaGROMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:12:13 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Bo Shen <voice.shen@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: fixes for 3.16 #2
Date: Fri, 18 Jul 2014 16:12:10 +0200
Message-ID: <1405692730-31284-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This is the latest regressions that we found while testing the at91sam9n12 and
at91sam9x5 platforms following our move to CCF.
I created a pull-request this time because I have 3 patches: there should be
no conflict anyway. This tag does not contain the fix that Olof had taken during
previous -rc cycle on purpose: this way it won't appear twice in the history.

Thanks, best regards,

The following changes since commit 971dc9ce106110745f246337f229013589354536:

  ARM: at91/dt: sam9261: remove slow RC osc (2014-06-25 18:00:17 +0200)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to e0d69e119fc6bf7cc3c9f791478108c1b925bb2e:

  ARM: at91/dt: add missing clocks property to pwm node in sam9x5.dtsi (2014-07-18 15:56:35 +0200)

----------------------------------------------------------------
Second AT91 fixes series for 3.16
- fix clock definitions after the move to CCF for:
  - at91sam9n12 (ohci)
  - at91sam9x5 (ohci, pwm)

----------------------------------------------------------------
Bo Shen (1):
      ARM: at91: at91sam9x5: correct typo error for ohci clock

Boris BREZILLON (2):
      ARM: at91/dt: fix usb0 clocks definition in sam9n12 dtsi
      ARM: at91/dt: add missing clocks property to pwm node in sam9x5.dtsi

 arch/arm/boot/dts/at91sam9n12.dtsi | 2 +-
 arch/arm/boot/dts/at91sam9x5.dtsi  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
Nicolas Ferre
