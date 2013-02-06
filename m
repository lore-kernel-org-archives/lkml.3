Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab3BFWNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:13:00 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:55145 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758691Ab3BFWM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:12:56 -0500
MIME-Version: 1.0
Date: Wed, 6 Feb 2013 23:12:55 +0100
Message-ID: <CACRpkdZHJfo7gpCtbwQyKUYsd5WT2yAH3v4YqTVP8F7x8qEejQ@mail.gmail.com>
Subject: [GIT PULL] late pinctrl fixes for the v3.8 rc:s
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Barry Song <Baohua.Song@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

sorry for this late pull request. Two patches appeared as of late, one
was completely
news to me, the other one was rotated in -next for the next merge window but
turned out to be a showstopper.

Please pull them in!

Yours,
Linus Walleij


The following changes since commit 88b62b915b0b7e25870eb0604ed9a92ba4bfc9f7:

  Linux 3.8-rc6 (2013-02-01 12:08:14 +1100)

are available in the git repository at:

  http://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-for-v3.8-late

for you to fetch changes up to 228f1ce9b8e9e63c3ffc1b03b64d77277cacb89f:

  pinctrl: sirf: replace of_gpio_simple_xlate by sirf specific
of_xlate (2013-02-05 15:27:39 +0100)

----------------------------------------------------------------
Late pinctrl fixes. Luckily just two patches:
- Exynos Kconfig fixup
- SIRF DT translation bug

----------------------------------------------------------------
Barry Song (1):
      pinctrl: sirf: replace of_gpio_simple_xlate by sirf specific of_xlate

Kukjin Kim (1):
      pinctrl: exynos: change PINCTRL_EXYNOS option

 arch/arm/mach-exynos/Kconfig   |  2 +-
 drivers/pinctrl/Kconfig        |  4 ++--
 drivers/pinctrl/Makefile       |  2 +-
 drivers/pinctrl/pinctrl-sirf.c | 18 ++++++++++++++++++
 4 files changed, 22 insertions(+), 4 deletions(-)
