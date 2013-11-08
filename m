Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab3KHPI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:08:26 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:47885 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab3KHPIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:08:23 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, <herbert@gondor.hengli.com.au>,
        <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <eric@eukrea.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH RESEND 0/7] crypto: at91/atmel: add Device Tree support
Date: Fri, 8 Nov 2013 16:08:09 +0100
Message-ID: <cover.1383922546.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds Device Tree support to the Atmel crypto drivers 
(AES/[T]DES/SHA). The Device Tree entries are very simple and only
declare the reg/irq values and the link to DMA.

Some trivial patches are preceding this move to Device Tree to clean
things up beforehand.

The series has already been sent but a little bit scattered. So I collect
everything, this time.

Nicolas Ferre (7):
  ARM: at91/dt/trivial: use macro for AES irq type
  ARM: at91/dt/trivial: before sama5d3, Atmel MPU were using at91 prefix
  ARM: at91/dt/sama5d3: add DMA information to SHA/AES/TDES nodes
  crypto: atmel-aes - add support for Device Tree
  crypto: atmel-tdes - add support for Device Tree
  crypto: atmel-sha - add support for Device Tree
  crypto: atmel-sha - add sha information to the log

 .../devicetree/bindings/crypto/atmel-crypto.txt    |  68 ++++++++++
 arch/arm/boot/dts/sama5d3.dtsi                     |  16 ++-
 drivers/crypto/atmel-aes.c                         | 143 ++++++++++++++-------
 drivers/crypto/atmel-sha.c                         | 103 +++++++++++----
 drivers/crypto/atmel-tdes.c                        | 143 ++++++++++++++-------
 5 files changed, 346 insertions(+), 127 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/atmel-crypto.txt

-- 
1.8.2.2

