Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946502Ab3BHNiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 08:38:03 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:52350 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946062Ab3BHNh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 08:37:59 -0500
MIME-Version: 1.0
Date: Fri, 8 Feb 2013 14:37:58 +0100
Message-ID: <CACRpkdbC+UnoxOj8AJFteYy+sjYe8+OUnT1Tyc_qBZH4Wy6sww@mail.gmail.com>
Subject: [GIT PULL] ab8500-dependent MFD functions for GPIO IRQs
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

could you please pull these changes into your MFD branch for the
next merge window?

These should be merged on top of Lee Jones' patch stack and
deal with how the GPIO IRQs are handled.

I based this off v3.8-rc6 as your branch appear to be.
If there are conflicts you need help with, tell me if you want me
to rebase it on your for-next branch or any other baseline.

After this I have only one ACKed patch in the pinctrl tree
that may conflict any other stuff, and that's this one:
http://git.kernel.org/?p=linux/kernel/git/linusw/linux-pinctrl.git;a=patch;h=56813f798e8cb3f79a25e0523e782d910f376083

This is in the middle of a branch that has been used as
a baseline by others and by other commits in the pinctrl
tree, so sadly I cannot take it out.

Please pull it in!

The following changes since commit 88b62b915b0b7e25870eb0604ed9a92ba4bfc9f7:

  Linux 3.8-rc6 (2013-02-01 12:08:14 +1100)

are available in the git repository at:

  http://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
abx500-pinctrl-for-mfd

for you to fetch changes up to e64d905e28031031c52db403826cd3bfe060b181:

  mfd: ab8500: allow AB9540 based devices to use ABX500 pinctrl
(2013-02-08 14:25:34 +0100)

----------------------------------------------------------------
Lee Jones (4):
      mfd: ab8500: prepare to handle AB8500 GPIO's IRQs correctly
      mfd: ab8500: provide a irq_set_type() function
      mfd: ab8500: ensure new AB8500 pinctrl driver is probed correctly
      mfd: ab8500: allow AB9540 based devices to use ABX500 pinctrl

Linus Walleij (1):
      mfd: ab8500: actually handle the AB8500 GPIO IRQs correctly

 drivers/mfd/ab8500-core.c | 53 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 3 deletions(-)


Yours,
Linus Walleij
