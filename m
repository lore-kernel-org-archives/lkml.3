Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaJVRBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 13:01:32 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:36350 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaJVRBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 13:01:31 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: fixes for 3.18 #1
Date: Wed, 22 Oct 2014 19:01:27 +0200
Message-ID: <1413997287-9855-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This is my first batch of fixes for 3.18.
The power/reset driver part is there because it was introduced through arm-soc
and it seems that it's better to continue like that.
The MAINTAINERS entry is better if included the soonest.

Note as well that it's my first pull-request from my newly created kernel.org
account: I hope that everything is done properly ;-)

Thanks, bye,

The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-fixes

for you to fetch changes up to 106c67af2fb938880edbf43b49dabbd8d2534839:

  ARM: at91/dt: sam9263: fix PLLB frequencies (2014-10-22 10:08:22 +0200)

----------------------------------------------------------------
First AT91 fixes for 3.18:
- one more MAINTAINERS entry for the SSC driver
- a fix for the newly introduced power/reset driver
- a fix on at91sam9263 USB due to PLLB misconfiguration

----------------------------------------------------------------
Alexandre Belloni (1):
      power: reset: at91-reset: fix power down register

Bo Shen (1):
      MAINTAINERS: add atmel ssc driver maintainer entry

Boris Brezillon (1):
      ARM: at91/dt: sam9263: fix PLLB frequencies

 MAINTAINERS                        | 7 +++++++
 arch/arm/boot/dts/at91sam9263.dtsi | 5 +++--
 drivers/power/reset/at91-reset.c   | 4 ++--
 3 files changed, 12 insertions(+), 4 deletions(-)

-- 
Nicolas Ferre
