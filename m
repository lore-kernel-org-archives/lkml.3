Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945923AbaD3RgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:36:16 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:59033 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422723AbaD3RgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:36:15 -0400
MIME-Version: 1.0
Date: Wed, 30 Apr 2014 10:36:14 -0700
Message-ID: <CACRpkdbgPaLjgQU5htJYzn-45MyxyqiQpcinr9nzmfp=8hf3Mw@mail.gmail.com>
Subject: [GIT PULL] pinctrl fixes for the v3.15-rc series
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a small set of pin control fixes for the v3.15 series.
All are individual driver fixes and quite self-contained. One
of them tagged for stable.

Please pull it in!

Yours,
Linus Walleij


The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:

  Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.15-3

for you to fetch changes up to 0c66c5628bbb5e96360032440f53a6cb6f8973d0:

  sh-pfc: r8a7791: Fix definition of MOD_SEL3 (2014-04-23 16:09:53 +0200)

----------------------------------------------------------------
Pin control fixes for v3.15:

- Signedness bug in the TB10x

- GPIO inversion fix for the AS3722

- Clear pending pin interrups enabled in the bootloader in the
  pinctrl-single driver

- Minor pin definition fixes for the PFC/Renesas driver

----------------------------------------------------------------
Andrew Bresticker (1):
      pinctrl: as3722: fix handling of GPIO invert bit

Christian Ruppert (1):
      pinctrl/TB10x: Fix signedness bug

Guido Piasenza (1):
      sh-pfc: r8a7790: Fix definition of IPSR5

Phil Edworthy (1):
      sh-pfc: r8a7791: Fix definition of MOD_SEL3

Tony Lindgren (1):
      pinctrl: single: Clear pin interrupts enabled by bootloader

 drivers/pinctrl/pinctrl-as3722.c     | 17 +++++++++++------
 drivers/pinctrl/pinctrl-single.c     | 13 +++++++++++++
 drivers/pinctrl/pinctrl-tb10x.c      |  3 +--
 drivers/pinctrl/sh-pfc/pfc-r8a7790.c |  3 +--
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c |  2 +-
 5 files changed, 27 insertions(+), 11 deletions(-)
