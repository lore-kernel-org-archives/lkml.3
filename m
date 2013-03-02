Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3CBOZS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 09:25:18 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:54736 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab3CBOZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 09:25:16 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 2 Mar 2013 14:24:53 +0000
X-Google-Sender-Auth: ykXV7Vln7B6lEzciXKwvf68k3YM
Message-ID: <CACxGe6sweLxtsW9OYb8m7esYguGmStEsuZc0tOgZN6H5Zfy1+g@mail.gmail.com>
Subject: [GIT PULL] gpio changes for v3.9; second round
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull, I missed a few things in the first gpio request I sent.

Thanks,
g.

The following changes since commit b0af9cd9aab60ceb17d3ebabb9fdf4ff0a99cf50:

  Merge tag 'lzo-update-signature-20130226' of
git://github.com/markus-oberhumer/linux (2013-02-28 20:45:52 -0800)

are available in the git repository at:


  git://git.secretlab.ca/git/linux tags/gpio-for-linus

for you to fetch changes up to 4710e74246a6496b65c8d28ef4a3144a7958264b:

  gpio/tegra: assume CONFIG_OF (2013-03-02 13:20:22 +0000)

----------------------------------------------------------------
2nd round of GPIO changes for Linux 3.9

This branch contains a few bug fixes that I missed the first time around
and updates to the gpio_desc series included in the first pull request.

----------------------------------------------------------------
Alexandre Courbot (3):
      gpiolib: check descriptors validity before use
      gpiolib: use const parameters when possible
      gpiolib: move comment to right function

Gabriel Fernandez (1):
      gpio/stmpe: pass DT node to irqdomain

Mika Westerberg (1):
      gpio/gpio-ich: fix ichx_gpio_check_available() return what callers expect

Stephen Warren (1):
      gpio/tegra: assume CONFIG_OF

 drivers/gpio/gpio-ich.c   |    4 +-
 drivers/gpio/gpio-stmpe.c |    7 ++-
 drivers/gpio/gpio-tegra.c |   11 ++--
 drivers/gpio/gpiolib.c    |  143 ++++++++++++++++++++++++++-------------------
 4 files changed, 94 insertions(+), 71 deletions(-)


--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
