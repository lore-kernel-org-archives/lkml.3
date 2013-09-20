Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab3ITN0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:26:12 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:58802 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab3ITN0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:26:10 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2 0/3] OMAP3 ROM Random Number Generator support
Date: Fri, 20 Sep 2013 15:25:04 +0200
Message-Id: <1379683507-30793-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379534757-20870-1-git-send-email-pali.rohar@gmail.com>
References: <1379534757-20870-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adding support for OMAP3 ROM Random Number Generator on Nokia N900.
In previous version I forgot to send patch which changing clk dev id to new driver name.

Pali Rohár (3):
  omap2: Change clk dev id for rng to omap3-rom-rng
  hwrng: OMAP3 ROM Random Number Generator support
  RX-51: Add support for OMAP3 ROM Random Number Generator

 arch/arm/mach-omap2/board-rx51-peripherals.c |   19 ++++
 arch/arm/mach-omap2/cclock3xxx_data.c        |    2 +-
 arch/arm/mach-omap2/omap-secure.c            |   11 ++
 arch/arm/mach-omap2/omap-secure.h            |    1 +
 drivers/char/hw_random/Kconfig               |   13 +++
 drivers/char/hw_random/Makefile              |    1 +
 drivers/char/hw_random/omap3-rom-rng.c       |  141 ++++++++++++++++++++++++++
 7 files changed, 187 insertions(+), 1 deletion(-)
 create mode 100644 drivers/char/hw_random/omap3-rom-rng.c

-- 
1.7.10.4

