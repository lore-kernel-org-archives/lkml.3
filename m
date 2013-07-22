Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab3GVXy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 19:54:58 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:36176 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab3GVXy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 19:54:57 -0400
MIME-Version: 1.0
Date: Tue, 23 Jul 2013 01:54:56 +0200
Message-ID: <CACRpkdZ2110vCrP2vgPBN3EoTB40BgKyr9U4Tqd_uFTwmG-BNA@mail.gmail.com>
Subject: [GIT PULL] GPIO fixes for v3.11-rc2
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a round of GPIO fixes for the rc series. The OMAP patches have
been around since around the merge window, but since they first
caused more breakage I let them boil in -next for a while. These should
be fine now.

Please pull them in!

Yours,
Linus Walleij


The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-for-v3.11-2

for you to fetch changes up to afe8ce9b29c487ea7f62faa936b6abb84e0b8815:

  drivers: gpio: msm: Fix the error condition for reading ngpio
(2013-07-20 23:33:33 +0200)

----------------------------------------------------------------
A first round of GPIO fixes for the v3.11 series:
- OMAP device tree boot fix
- Handle an error condition in the MSM driver

----------------------------------------------------------------
Javier Martinez Canillas (3):
      gpio/omap: don't create an IRQ mapping for every GPIO on DT
      gpio/omap: auto request GPIO as input if used as IRQ via DT
      gpio/omap: fix build error when OF_GPIO is not defined.

Rohit Vaswani (1):
      drivers: gpio: msm: Fix the error condition for reading ngpio

 drivers/gpio/gpio-msm-v2.c |  2 +-
 drivers/gpio/gpio-omap.c   | 84 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 71 insertions(+), 15 deletions(-)
