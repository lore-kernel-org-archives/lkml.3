Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbbALV5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:57:51 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45195 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbbALV5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:57:50 -0500
MIME-Version: 1.0
Date: Mon, 12 Jan 2015 22:57:49 +0100
Message-ID: <CACRpkdZFGLWF3h8AjKiUMPWNheLy+dFG4cYnsYXc_CZC+BpouA@mail.gmail.com>
Subject: [GIT PULL] GPIO fixes for the v3.19 series
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are some GPIO fixes, mainly affecting the DLN2 IRQ handling.
Nothing special about them, just fixes.

Please pull them in!

Yours,
Linus Walleij

The following changes since commit b7392d2247cfe6771f95d256374f1a8e6a6f48d6:

  Linux 3.19-rc2 (2014-12-28 16:49:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.19-3

for you to fetch changes up to 96b932b84409a5c1037827b4432a2b53adc09a61:

  gpio: dln2: use bus_sync_unlock instead of scheduling work
(2015-01-09 07:57:35 +0100)

----------------------------------------------------------------
Some GPIO fixes for the v3.19 series:
- Three patches fixing IRQ handling for the DLN2
- Null pointer handling for grgpio

----------------------------------------------------------------
Axel Lin (2):
      gpio: dln2: Fix gpio output value in dln2_gpio_direction_output()
      gpio: grgpio: Avoid potential NULL pointer dereference

Octavian Purdila (2):
      gpio: dln2: fix issue when an IRQ is unmasked then enabled
      gpio: dln2: use bus_sync_unlock instead of scheduling work

 drivers/gpio/gpio-dln2.c   | 156 +++++++++++++++++++--------------------------
 drivers/gpio/gpio-grgpio.c |   3 +-
 2 files changed, 69 insertions(+), 90 deletions(-)
