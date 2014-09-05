Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaIEQBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:01:40 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:51949 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaIEQBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:01:39 -0400
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
Subject: [GIT PULL] at91: fixes for 3.17 #1
Date: Fri, 5 Sep 2014 18:01:36 +0200
Message-ID: <1409932896-4533-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

Little pull-request for fixing CCF conversion done during 3.17.
The use of at91sam9g20 proper compatibility string is useful when booting
without U-Boot (this is why we discover it now).

Thanks, best regards,

The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to ea4fc621adec8956944ecdb9a36c549cba8718c0:

  ARM: at91/dt: rm9200: fix usb clock definition (2014-09-05 17:36:12 +0200)

----------------------------------------------------------------
First AT91 fixes batch for 3.17:
- compatibility string precision
- clock registration and USB DT fix for at91rm9200

----------------------------------------------------------------
Alexandre Belloni (2):
      ARM: at91: rm9200: fix clock registration
      ARM: at91/dt: rm9200: fix usb clock definition

Gaël PORTAY (1):
      ARM: at91/dt: sam9g20: set at91sam9g20 pllb driver

 arch/arm/boot/dts/at91rm9200.dtsi    |  2 +-
 arch/arm/boot/dts/at91sam9g20.dtsi   |  1 +
 arch/arm/mach-at91/board-dt-rm9200.c | 11 ++++++++++-
 3 files changed, 12 insertions(+), 2 deletions(-)

-- 
Nicolas Ferre
