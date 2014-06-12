Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbaFLJ1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 05:27:18 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:60166 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553AbaFLJ1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:27:17 -0400
MIME-Version: 1.0
Date: Thu, 12 Jun 2014 11:27:16 +0200
Message-ID: <CAPDyKFqjSgZs3o5qPjsFzrEHPt5_b7hwdLkqq3CdEM-OjST0JQ@mail.gmail.com>
Subject: [GIT PULL] MMC fixes for v.3.16
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Linus <torvalds@linux-foundation.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Chris Ball <chris@printf.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are some mmc fixes for 3.16.

- Fix some various compiler warnings.
- Make atmel-mci compile again.
- Fix regression for sdhci-msm.

Information also collected in the signed tag.

Kind regards
Ulf Hansson


The following changes since commit 5c02c392cd2320e8d612376d6b72b6548a680923:

  Merge tag 'virtio-next-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux (2014-06-11
21:10:33 -0700)

are available in the git repository at:


  git://git.linaro.org/people/ulf.hansson/mmc.git tags/mmc-v3.16-2

for you to fetch changes up to 5d01b7684b7ebade6d9ea9c94a31357aec731ecd:

  mmc: simplify SDHCI Kconfig dependencies (2014-06-12 10:51:14 +0200)

----------------------------------------------------------------
- Fix some various compiler warnings.
- Make atmel-mci compile again.
- Fix regression for sdhci-msm.

----------------------------------------------------------------
Arnd Bergmann (4):
      mmc: atmel-mci: incude asm/cacheclush.h
      mmc: mvsdio: avoid compiler warning
      mmc: omap: don't select TPS65010
      mmc: simplify SDHCI Kconfig dependencies

Guennadi Liakhovetski (1):
      mmc: usdhi6rol0: fix compiler warnings

Stephen Boyd (1):
      mmc: sdhci-msm: Fix fallout from sdhci refactoring

 drivers/mmc/host/Kconfig      |   10 ++++------
 drivers/mmc/host/atmel-mci.c  |    1 +
 drivers/mmc/host/mvsdio.c     |    2 +-
 drivers/mmc/host/sdhci-msm.c  |    4 ++++
 drivers/mmc/host/usdhi6rol0.c |   10 +++++-----
 5 files changed, 15 insertions(+), 12 deletions(-)
