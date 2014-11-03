Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaKCRnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:43:21 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:20829 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaKCRnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:43:20 -0500
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
Subject: [GIT PULL] at91: dt for 3.19 #1
Date: Mon, 3 Nov 2014 18:43:17 +0100
Message-ID: <1415036597-3501-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

Very little DT update for AT91. More will come but I want to send this first
batch soon so it doesn't get in the way of larger modifications.

Thanks, best regards,

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-dt

for you to fetch changes up to 2667c6adfcf686e8c5a5b56e8c7c65af001df2cb:

  ARM: at91/dt: at91sam9263: Add CAN device nodes (2014-11-03 11:34:33 +0100)

----------------------------------------------------------------
First DT batch for 3.19:
- CAN device nodes for at91sam9263 and at91sam9x5
- at91sam9x5 DMA definitions for usart

----------------------------------------------------------------
Alexander Stein (2):
      ARM: at91/dt: at91sam9x5: Add CAN device nodes
      ARM: at91/dt: at91sam9263: Add CAN device nodes

Jiri Prchal (1):
      ARM: at91: at91sam9x5 dt: add usart dma definitions to dt

Nicolas Ferre (1):
      ARM: at91/dt/trivial: at91sam9x5_can.dtsi: comment and whitespace fixes

 arch/arm/boot/dts/at91sam9263.dtsi       | 19 ++++++++++++
 arch/arm/boot/dts/at91sam9x25.dtsi       |  1 +
 arch/arm/boot/dts/at91sam9x35.dtsi       |  1 +
 arch/arm/boot/dts/at91sam9x5.dtsi        | 12 ++++++++
 arch/arm/boot/dts/at91sam9x5_can.dtsi    | 50 ++++++++++++++++++++++++++++----
 arch/arm/boot/dts/at91sam9x5_usart3.dtsi |  3 ++
 6 files changed, 81 insertions(+), 5 deletions(-)

-- 
Nicolas Ferre
