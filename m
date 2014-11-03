Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaKCOrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:47:51 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:63785 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaKCOru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:47:50 -0500
MIME-Version: 1.0
Date: Mon, 3 Nov 2014 15:47:49 +0100
Message-ID: <CACRpkdb4xYmz3d6O3GVvffAx2+oWfsRwMyjQULXj5gAKe1j83g@mail.gmail.com>
Subject: [GIT PULL] pin control fixes for v3.18
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this kernel cycle has been calm for both pin control and GPIO
so far but here are three pin control patches for you anyway,
only really dealing with Baytrail.

Please pull them in!

Yours,
Linus Walleij

The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.18-2

for you to fetch changes up to d90c33818967c5e5371961604ad98b4dea4fa3f4:

  pinctrl: baytrail: show output gpio state correctly on Intel
Baytrail (2014-10-28 11:16:26 +0100)

----------------------------------------------------------------
Pin control fixes for the v3.18 series:
- Two fixes for the Baytrail driver affecting IRQs and
  output state in sysfs
- Use the linux-gpio mailing list also for pinctrl patches

----------------------------------------------------------------
David Cohen (2):
      pinctrl: use linux-gpio mailing list
      pinctrl: baytrail: show output gpio state correctly on Intel Baytrail

Loic Poulain (1):
      pinctrl: baytrail: Clear DIRECT_IRQ bit

 MAINTAINERS                        | 1 +
 drivers/pinctrl/pinctrl-baytrail.c | 8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)
