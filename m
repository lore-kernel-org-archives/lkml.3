Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3A3Ji0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:38:26 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:5559 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab3A3JiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:38:19 -0500
Message-ID: <5108EA04.80002@atmel.com>
Date: Wed, 30 Jan 2013 10:38:12 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Robert Nelson <Robert.Nelson@digikey.com>
Subject: [GIT PULL] at91: fixes for 3.8-rc6
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

Here are two little DT fixes that will fix the use of
USART3 on at91sam9x5 platforms.


The following changes since commit 949db153b6466c6f7cad5a427ecea94985927311:

  Linux 3.8-rc5 (2013-01-25 11:57:28 -0800)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to 7d4cfece23f535b60496d88a717a3d7bfca50187:

  ARM: at91/at91sam9x5.dtsi: fix usart3 TXD (2013-01-30 10:09:17 +0100)

----------------------------------------------------------------
Two little Device Tree fixes for USART on at91sam9x5.

----------------------------------------------------------------
Douglas Gilbert (1):
      ARM: at91/at91sam9x5.dtsi: fix usart3 TXD

Robert Nelson (1):
      ARM: at91: at91sam9x5: fix usart3 pinctrl name

 arch/arm/boot/dts/at91sam9x5.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Thanks, bye,
-- 
Nicolas Ferre
