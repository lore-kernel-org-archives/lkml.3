Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab3LSXD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:03:27 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:16854 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab3LSXDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:03:21 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Boris BREZILLON <b.brezillon@overkiz.com>, Bo Shen <voice.shen@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: dt for 3.14 #2
Date: Fri, 20 Dec 2013 00:03:18 +0100
Message-ID: <1387494198-20329-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

Some more DT material for 3.14 based on top of what I already sent (in
your at91/dt branch). Nothing really surprising...

Thanks, best regards,

The following changes since commit ca594844e4a53f778811c06feef60bdf36bc5fec:

  ARM: at91/at91rm9200ek.dts: rearrange nodes in address ascending order (2013-12-09 15:08:57 +0100)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-dt2

for you to fetch changes up to 45e5c2cb6bc1c52c7134f898ea326a422dd75761:

  ARM: at91/dt: add clk properties to sama5d3 TDES device node (2013-12-19 23:00:06 +0100)

----------------------------------------------------------------
Second DT pull-request for 3.14
- now that PWM driver is on its way to mainline,
  we can integrate the DT entries
- As an example, use PWM for at91sam9m10g45ek leds
- Addition of clock specification for newly introduced
  crypto DT entries

----------------------------------------------------------------
Bo Shen (2):
      ARM: at91: add PWM device node
      ARM: at91: at91sam9m10g45ek: switch to PWM leds

Boris BREZILLON (3):
      ARM: at91/dt: add clk properties to sama5d3 SHA device node
      ARM: at91/dt: add clk properties to sama5d3 AES device node
      ARM: at91/dt: add clk properties to sama5d3 TDES device node

 arch/arm/boot/dts/at91sam9263.dtsi     |  9 +++++++++
 arch/arm/boot/dts/at91sam9g45.dtsi     |  9 +++++++++
 arch/arm/boot/dts/at91sam9m10g45ek.dts | 25 +++++++++++++++++++++++--
 arch/arm/boot/dts/at91sam9n12.dtsi     |  9 +++++++++
 arch/arm/boot/dts/at91sam9x5.dtsi      |  9 +++++++++
 arch/arm/boot/dts/sama5d3.dtsi         | 16 ++++++++++++++++
 6 files changed, 75 insertions(+), 2 deletions(-)

-- 
Nicolas Ferre
