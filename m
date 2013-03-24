Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab3CXIv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 04:51:27 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:45837 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab3CXIvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 04:51:22 -0400
MIME-Version: 1.0
Date: Sun, 24 Mar 2013 09:51:21 +0100
Message-ID: <CACRpkdZ511nJiqMv1h9uce+s3eDDMVgYGHX=mj0LiM-htSXVyQ@mail.gmail.com>
Subject: [GIT PULL] pinctrl fixes for v3.9
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are some assorted pinctrl fixes for the v3.9 rc series.
Just bug fixes, basically.

Please pull them in, detailed info in the tag.

Yours,
Linus Walleij


The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-fixes-for-v3.9

for you to fetch changes up to 740924a267e85de09707ea158bbf594b4d8bae01:

  pinmux: forbid mux_usecount to be set at UINT_MAX (2013-03-21 19:26:18 +0100)

----------------------------------------------------------------
Here are a few pinctrl fixes for the v3.9 rc series:
- Usecount bounds checking so we do not go below zero on
  mux usecounts.
- Loop range checking in GPIO ranges in the DT range parser.
- Proper print in debugfs for pinconf state.
- Fix compilation bug in generic pinconf code.
- Minor bugfixes to abx500 and mvebu drivers.

----------------------------------------------------------------
Axel Lin (1):
      pinctrl: abx500: Fix checking if pin use AlternateFunction register

Haojian Zhuang (1):
      gpio: fix wrong checking condition for gpio range

Laurent Pinchart (1):
      pinctrl: Print the correct information in debugfs pinconf-state file

Richard Genoud (1):
      pinmux: forbid mux_usecount to be set at UINT_MAX

Sachin Kamat (1):
      pinctrl: generic: Fix compilation error

Simon Guinot (1):
      pinctrl: mvebu: fix checking for SoC specific controls

 drivers/gpio/gpiolib-of.c             | 5 ++---
 drivers/pinctrl/mvebu/pinctrl-mvebu.c | 2 +-
 drivers/pinctrl/pinconf.c             | 2 +-
 drivers/pinctrl/pinconf.h             | 2 +-
 drivers/pinctrl/pinctrl-abx500.c      | 2 +-
 drivers/pinctrl/pinmux.c              | 5 +++++
 6 files changed, 11 insertions(+), 7 deletions(-)
