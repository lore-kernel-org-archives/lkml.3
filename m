Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab3EBQ6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 12:58:41 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:33162 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab3EBQ6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 12:58:37 -0400
MIME-Version: 1.0
Date: Thu, 2 May 2013 18:58:36 +0200
Message-ID: <CACRpkdY-US0RdcZU_yYv1A_7YnvVph=g0M=_k60Wwz_WONBUyw@mail.gmail.com>
Subject: [GIT PULL] two pinctrl fixes for v3.10
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Mack <zonque@gmail.com>, Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

no point in saving the first pinctrl fixes for the -rc series when my testers
are already on my back for these. Here are two additional patches, please
pull them in.

Yours,
Linus Walleij


The following changes since commit 56847d857cb0c3ee78c22ce776a26f88d9ffd4d4:

  Merge branch 'akpm' (incoming from Andrew) (2013-04-29 19:47:50 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-fixes-v3.10-1

for you to fetch changes up to d463f82d22f90096d1352de3837b1602a3410b5d:

  pinctrl: fix mutex deadlock in get_pinctrl_dev_from_of_node()
(2013-04-30 13:02:04 +0200)

----------------------------------------------------------------
Two fixes to the pinctrl subsystem for v3.10:
- A quite apparent mutex fix in an untested codepath
- A compile warning fix in the plgpio driver

----------------------------------------------------------------
Daniel Mack (1):
      pinctrl: fix mutex deadlock in get_pinctrl_dev_from_of_node()

Jingoo Han (1):
      pinctrl: plgpio: add CONFIG_PM_SLEEP to suspend/resume functions

 drivers/pinctrl/core.c                 | 2 +-
 drivers/pinctrl/spear/pinctrl-plgpio.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)
