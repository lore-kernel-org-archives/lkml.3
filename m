Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3IRUHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 16:07:49 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:39631 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab3IRUHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 16:07:48 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 0/2] OMAP3 ROM Random Number Generator support
Date: Wed, 18 Sep 2013 22:05:55 +0200
Message-Id: <1379534757-20870-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <201303281854.02847@pali>
References: <201303281854.02847@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This two patches adding support for OMAP3 ROM Random Number Generator on Nokia N900.

Pali Rohár (2):
  hwrng: OMAP3 ROM Random Number Generator support
  RX-51: Add support for OMAP3 ROM Random Number Generator

 arch/arm/mach-omap2/board-rx51.c       |   10 +++
 arch/arm/mach-omap2/omap-secure.c      |   11 +++
 arch/arm/mach-omap2/omap-secure.h      |    1 +
 drivers/char/hw_random/Kconfig         |   13 +++
 drivers/char/hw_random/Makefile        |    1 +
 drivers/char/hw_random/omap3-rom-rng.c |  145 ++++++++++++++++++++++++++++++++
 6 files changed, 181 insertions(+)
 create mode 100644 drivers/char/hw_random/omap3-rom-rng.c

-- 
1.7.10.4

