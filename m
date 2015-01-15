Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbbAORJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:09:36 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:24315 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbbAORJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:09:34 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Josh Wu <josh.wu@atmel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: defconfig for 3.20 #1
Date: Thu, 15 Jan 2015 18:09:42 +0100
Message-ID: <1421341782-14355-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

A little defconfig update. If you want me to collect more patches before
sending you a more substantial one, let me know.

Thanks, bye,

The following changes since commit eaa27f34e91a14cdceed26ed6c6793ec1d186115:

  linux 3.19-rc4 (2015-01-11 12:44:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-defconfig

for you to fetch changes up to a1b282911b47a522f150eb715fb037628c5173fe:

  ARM: at91: sama5: enable atmel-isi and ov2640 in defconfig (2015-01-15 16:28:23 +0100)

----------------------------------------------------------------
First batch of defconfig update for 3.20:
- we remove DEBUG_LL from sama5 defconfig as all SoC are not compatible
- enable ISI and selected sensors

----------------------------------------------------------------
Josh Wu (1):
      ARM: at91: sama5: enable atmel-isi and ov2640 in defconfig

Maxime Ripard (1):
      ARM: at91/config: sama5: Remove DEBUG_LL

 arch/arm/configs/sama5_defconfig | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

-- 
Nicolas Ferre
