Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab3KHGqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 01:46:13 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58635 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3KHGqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 01:46:10 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>, linux-gpio@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/2] DaVinci: GPIO: fixes
Date: Fri,  8 Nov 2013 12:15:54 +0530
Message-Id: <1383893156-28010-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch series fixes gpio driver regestration
and offset check for unbanked gpio.

Lad, Prabhakar (2):
  gpio: davinci: Fix a check for unbanked gpio
  ARM: davinci: Fix number of resources passed to
    davinci_gpio_register() call

 arch/arm/mach-davinci/dm355.c  |    2 +-
 arch/arm/mach-davinci/dm365.c  |    2 +-
 arch/arm/mach-davinci/dm644x.c |    2 +-
 arch/arm/mach-davinci/dm646x.c |    2 +-
 drivers/gpio/gpio-davinci.c    |    4 +++-
 5 files changed, 7 insertions(+), 5 deletions(-)

-- 
1.7.9.5

