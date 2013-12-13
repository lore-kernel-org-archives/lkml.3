Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab3LMJFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 04:05:52 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:30488 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3LMJFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 04:05:48 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: drivers for 3.14 #1
Date: Fri, 13 Dec 2013 10:05:45 +0100
Message-ID: <1386925545-10495-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This is a "drivers" series that adds Device Tree support to 
Atmel crypto drivers (AES/[T]DES/SHA). As the DT part of this
addition is in at91-3.14-dt I thought it would be simpler to take
this series through arm-soc. I asked and got Herbert's blessing.

The Device Tree entries documented in these patches are very simple
and only declare the reg/irq values and the link to DMA.

Thanks, best regards,

The following changes since commit b46e837d8ef1f3c777bbf9513e2cdb5d87d6c374:

  ARM: at91/dt: remove old clk material (2013-12-02 15:31:29 +0100)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-drivers

for you to fetch changes up to 1ca5b7d95315c42cf0b78d33cd316e404a9f137c:

  crypto: atmel-sha - add sha information to the log (2013-12-12 18:39:36 +0100)

----------------------------------------------------------------
AT91 crypto drivers DT support:
- add DT to sha/des/aes existing drivers
- add DMA DT
- all documentation added to crypto/atmel-crypto.txt file

----------------------------------------------------------------
Nicolas Ferre (4):
      crypto: atmel-aes - add support for Device Tree
      crypto: atmel-tdes - add support for Device Tree
      crypto: atmel-sha - add support for Device Tree
      crypto: atmel-sha - add sha information to the log

 .../devicetree/bindings/crypto/atmel-crypto.txt    |  68 ++++++++++
 drivers/crypto/atmel-aes.c                         | 143 ++++++++++++++-------
 drivers/crypto/atmel-sha.c                         | 103 +++++++++++----
 drivers/crypto/atmel-tdes.c                        | 143 ++++++++++++++-------
 4 files changed, 334 insertions(+), 123 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/atmel-crypto.txt

-- 
Nicolas Ferre
