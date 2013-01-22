Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab3AVJhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:37:24 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:42284 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3AVJhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:37:23 -0500
MIME-Version: 1.0
Date: Tue, 22 Jan 2013 10:37:22 +0100
Message-ID: <CACRpkdZYZjsegccnAGKNNoX1RVPqV0272R5_2cWZQCNw_bq7bA@mail.gmail.com>
Subject: [GIT PULL] gpio fixes for v3.8 rc:s
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are some GPIO fixes I stacked up in my GPIO tree. Described in the
tag, please pull them in!

Yours,
Linus Walleij


The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/fixes-for-v3.8-rc4

for you to fetch changes up to 11c0ceec073cb35a1bedfdece701351cfc1da5b7:

  gpio: mvebu: Don't free chip label memory (2013-01-17 12:27:08 +0100)

----------------------------------------------------------------
GPIO fixes for the v3.8 series:
- Remove a bad #include from the Samsung driver
- Some Kconfig hazzle for the Samsungs
- Skip gpiolib registration on EXYNOS5440
- Don't free the MVEBU label

----------------------------------------------------------------
Kukjin Kim (4):
      gpio: samsung: remove inclusion <mach/regs-clock.h>
      gpio: samsung: fix pinctrl condition for exynos and exynos5440
      gpio: samsung: silent build warning for EXYNOS5 SoCs
      gpio: samsung: skip gpio lib registration for EXYNOS5440

Thierry Reding (1):
      gpio: mvebu: Don't free chip label memory

 drivers/gpio/gpio-mvebu.c   |  6 ------
 drivers/gpio/gpio-samsung.c | 14 +++++++-------
 2 files changed, 7 insertions(+), 13 deletions(-)
