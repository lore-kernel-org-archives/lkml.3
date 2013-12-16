Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3LPJSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:18:21 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:33351 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab3LPJSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:18:18 -0500
MIME-Version: 1.0
Date: Mon, 16 Dec 2013 10:18:17 +0100
Message-ID: <CACRpkdbBM6jW2jCJ9rjiK13ouyicw-OPZneg-z+=SA8NLavcVw@mail.gmail.com>
Subject: [GIT PULL] GPIO fixes for the v3.13 series
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Roger Quadros <rogerq@ti.com>,
        Valentine <valentine.barshak@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are more v3.13 GPIO material, all but one are long-standing bug
fixes that are also tagged for stable.

Please pull them in!

Yours,
Linus Walleij


The following changes since commit 374b105797c3d4f29c685f3be535c35f5689b30e:

  Linux 3.13-rc3 (2013-12-06 09:34:04 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.13-4

for you to fetch changes up to 8808b64daac68a2c85366c767a3ef850824ede74:

  gpio: rcar: Fix level interrupt handling (2013-12-12 20:53:05 +0100)

----------------------------------------------------------------
GPIO fixes for the v3.13 development cycle:

- Driver bug fixes for SH PFC, TWL4030, MSM and RCAR.

- Update the MAINTAINERS

----------------------------------------------------------------
Laurent Pinchart (1):
      sh-pfc: Fix PINMUX_GPIO macro

Linus Walleij (1):
      MAINTAINERS: update GPIO maintainers entry

Roger Quadros (1):
      gpio: twl4030: Fix regression for twl gpio LED output

Stephen Boyd (1):
      gpio: msm: Fix irq mask/unmask by writing bits instead of numbers

Valentine Barshak (1):
      gpio: rcar: Fix level interrupt handling

 MAINTAINERS                     |  6 ++++--
 drivers/gpio/gpio-msm-v2.c      |  4 ++--
 drivers/gpio/gpio-rcar.c        |  3 ++-
 drivers/gpio/gpio-twl4030.c     | 15 ++++++++++++---
 drivers/pinctrl/sh-pfc/sh_pfc.h |  2 +-
 5 files changed, 21 insertions(+), 9 deletions(-)
