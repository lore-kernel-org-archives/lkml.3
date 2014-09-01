Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbaIARjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 13:39:14 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:19289 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbaIARjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 13:39:12 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL 2/4] at91: DT for 3.18 #1
Date: Mon, 1 Sep 2014 19:38:45 +0200
Message-ID: <1409593127-24049-2-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1409593127-24049-1-git-send-email-nicolas.ferre@atmel.com>
References: <1409593127-24049-1-git-send-email-nicolas.ferre@atmel.com>
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This is basically the material that Maxime and Alexandre gave to me (thus
the merge of their pull-request). I resolved a conflict so it should not appear
when you merge with current 3.17-rc tree.

Thanks, best regards,

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-dt

for you to fetch changes up to 464d6e18639c4347dafd8dbcee270674dd3d8fba:

  Merge tag 'at91-dt-for-3.17' of git://git.kernel.org/pub/scm/linux/kernel/git/mripard/linux (2014-08-19 16:04:10 -0500)

----------------------------------------------------------------

First batch of AT91 DT material for 3.18:
- RAM controller rework for multiple controller SoCs
- shutdown controller addtion

----------------------------------------------------------------
Alexandre Belloni (2):
      ARM: at91/dt: sama5d3: define mpddr clock and ramc clocks
      ARM: at91/dt: at91sam9: use ddrck in ramc

Maxime Ripard (2):
      ARM: at91/dt: Declare a second ram controller when relevant
      ARM: at91/dt: sama5d3: Add shutdown controller

Nicolas Ferre (1):
      Merge tag 'at91-dt-for-3.17' of git://git.kernel.org/.../mripard/linux

 arch/arm/boot/dts/at91sam9263.dtsi | 10 +++++++---
 arch/arm/boot/dts/at91sam9g45.dtsi | 10 ++++++++--
 arch/arm/boot/dts/at91sam9n12.dtsi |  2 ++
 arch/arm/boot/dts/at91sam9x5.dtsi  |  2 ++
 arch/arm/boot/dts/sama5d3.dtsi     | 14 +++++++++++++-
 5 files changed, 32 insertions(+), 6 deletions(-)

-- 
Nicolas Ferre
