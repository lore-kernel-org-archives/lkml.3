Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaBLO6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 09:58:20 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:42043 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaBLO6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 09:58:18 -0500
MIME-Version: 1.0
Date: Wed, 12 Feb 2014 15:58:16 +0100
Message-ID: <CACRpkdZsU_Vdb3C_VLH6CUH830i2iPsPPb=ODw9oe7vFm3iUag@mail.gmail.com>
Subject: [GIT PULL] GPIO fixes for the v3.14 series
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are some accumulated patches with small fixes for this and
that in a few GPIO drivers, and a more important fix to an #ifdef
in the GPIO consumer header.

Please pull it in!

Yours,
Linus Walleij


The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.14-2

for you to fetch changes up to a3485d088516be4c2ae2890e8ad64321481f2857:

  gpio: consumer.h: Move forward declarations outside #ifdef
(2014-02-06 10:22:56 +0100)

----------------------------------------------------------------
A set of GPIO fixes for the v3.14 series:

- Get #ifdef's right in the <linux/gpio/consumer.h> header.

- Minor fixes to tb10x, clps711x, bcm281xx, intel-mid and
  xtensa GPIO drivers.

----------------------------------------------------------------
Axel Lin (2):
      gpio: clps711x: Add module alias to support module auto loading
      gpio: tb10x: GPIO_TB10X needs to select GENERIC_IRQ_CHIP

Baruch Siach (1):
      gpio: xtensa: fix build when XCHAL_HAVE_CP is 0

Lars-Peter Clausen (1):
      gpio: consumer.h: Move forward declarations outside #ifdef

Markus Mayer (1):
      gpio: bcm281xx: Update MODULE_AUTHOR

xinhui.pan (1):
      gpio: intel-mid: fix the incorrect return of idle callback

 drivers/gpio/Kconfig          |  1 +
 drivers/gpio/gpio-bcm-kona.c  |  4 ++--
 drivers/gpio/gpio-clps711x.c  |  1 +
 drivers/gpio/gpio-intel-mid.c |  4 ++--
 drivers/gpio/gpio-xtensa.c    | 16 ++++++++++++++++
 include/linux/gpio/consumer.h |  4 ++--
 6 files changed, 24 insertions(+), 6 deletions(-)
