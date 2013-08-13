Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab3HMG1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:27:21 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:63643 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab3HMG1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:27:20 -0400
MIME-Version: 1.0
Date: Tue, 13 Aug 2013 08:27:19 +0200
Message-ID: <CACRpkdZpfMSSx0oOzjkErN40hOQLcYraOUArn-pQAn06xJ7bVg@mail.gmail.com>
Subject: [GIT PULL] pinctrl fixes for v3.11
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are hopefully the last pin control fixes for v3.11, some
"barnsjukdomar" on the sunxi (AllWinner) driver. I would have
preferred oneliners at this point, but it's a new driver so...

Please pull them in!

Yours,
Linus Walleij

s expected.The following changes since commit
c095ba7224d8edc71dcef0d655911399a8bd4a3f:

  Linux 3.11-rc4 (2013-08-04 13:46:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-for-v3.11-3

for you to fetch changes up to 1bee963db9dd82e12566bdae6710defb1206b38b:

  pinctrl: sunxi: Add spinlocks (2013-08-07 21:57:17 +0200)

----------------------------------------------------------------
Fixes for the sunxi (AllWinner) pin control driver.
This was a new driver in this merge window, so some
post-merge hardening is happening.

----------------------------------------------------------------
Maxime Ripard (3):
      pinctrl: sunxi: Read register before writing to it in irq_set_type
      pinctrl: sunxi: Fix gpio_set behaviour
      pinctrl: sunxi: Add spinlocks

 drivers/pinctrl/pinctrl-sunxi.c | 66 ++++++++++++++++++++++++++++++++++++++---
 drivers/pinctrl/pinctrl-sunxi.h |  2 ++
 2 files changed, 64 insertions(+), 4 deletions(-)
