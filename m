Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbaKTJnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:43:31 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:38707 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaKTJn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:43:28 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, <mpm@selenic.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <peter@korsgaard.com>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH RESEND v2 0/4] hwrng: atmel: add DT support
Date: Thu, 20 Nov 2014 10:43:21 +0100
Message-ID: <cover.1416475860.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the patch series that Boris sent yesterday. I've just collected
"Acked-by" tags and resend it with updated cover letter.

This series adds DT support for the TRNG (True Random Generator) block and adds
missing trng nodes to at91sam9g45 dtsi files.

Herbert,
As you said that you can take this series, here is the latest vertion ready for you to
pick it up. Thanks for your help.

Bye,

Boris Brezillon (4):
  hwrng: atmel: use clk_prepapre_enable/_disable_unprepare
  hwrng: atmel: add DT support
  hwrng: atmel: Add TRNG DT binding doc
  ARM: at91/dt: add trng node to at91sam9g45

 Documentation/devicetree/bindings/hwrng/atmel-trng.txt | 16 ++++++++++++++++
 arch/arm/boot/dts/at91sam9g45.dtsi                     |  7 +++++++
 drivers/char/hw_random/Kconfig                         |  2 +-
 drivers/char/hw_random/atmel-rng.c                     | 15 +++++++++++----
 4 files changed, 35 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwrng/atmel-trng.txt

-- 
2.1.3

