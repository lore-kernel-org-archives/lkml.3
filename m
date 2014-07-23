Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbaGWMyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:54:54 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:42687 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaGWMyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:54:52 -0400
MIME-Version: 1.0
Date: Wed, 23 Jul 2014 14:54:51 +0200
Message-ID: <CACRpkda7-1cMyS5fyf1Rr+OamLmEYWeCe0VYJP_=4zSa-WFy7g@mail.gmail.com>
Subject: [GIT PULL] pin control fixes for v3.16
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are three pin control fixes for the v3.16 series. Sorry that some
of these arrive late, the summer heat in Sweden makes me slow.

Please pull them in.

Yours,
Linus Walleij


The following changes since commit 1795cd9b3a91d4b5473c97f491d63892442212ab:

  Linux 3.16-rc5 (2014-07-13 14:04:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.16-3

for you to fetch changes up to fe132649b5b28c19bc657d167c232180774739f8:

  gpio: rcar: Add support for DT IRQ flags (2014-07-15 20:55:15 +0200)

----------------------------------------------------------------
Pin control fixes for v3.16:
- An IRQ handling fix for the STi driver, also for stable
- Another IRQ fix for the RCAR GPIO driver
- A MAINTAINERS entry

----------------------------------------------------------------
Laurent Pinchart (2):
      MAINTAINERS: Add entry for the Renesas pin controller driver
      gpio: rcar: Add support for DT IRQ flags

Maxime COQUELIN (1):
      pinctrl: st: Fix irqmux handler

 MAINTAINERS                  | 6 ++++++
 drivers/gpio/gpio-rcar.c     | 1 +
 drivers/pinctrl/pinctrl-st.c | 2 +-
 3 files changed, 8 insertions(+), 1 deletion(-)
