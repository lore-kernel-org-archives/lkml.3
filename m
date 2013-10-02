Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3JBInJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 04:43:09 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:44017 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab3JBInH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 04:43:07 -0400
MIME-Version: 1.0
Date: Wed, 2 Oct 2013 10:43:06 +0200
Message-ID: <CACRpkdaZNutc0qG+u57nia9uPXxe9vPPHq7y+JYXPCqdYFtQ0w@mail.gmail.com>
Subject: [GIT PULL] pinctrl fixes for v3.12
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        =?ISO-8859-1?Q?Vincent_Stehl=E9?= <vincent.stehle@laposte.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a smallish batch of fixes for the pin control stuff
in v3.12. All but the topmost commit were tested in Linux-next
prior to Stephens leave.

Please pull them in!

Yours,
Linus Walleij


The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.12-2

for you to fetch changes up to 7fd9ddd5f71078df34f2fd7d375fbf0a8d92f9cc:

  pinctrl: palmas: do not abort pin configuration for BIAS_DEFAULT
(2013-09-27 16:22:43 +0200)

----------------------------------------------------------------
Pin control fixes for the v3.12 series:

- Various build warning fixes.

- Correct the S5P pin count.

- Handle BIAS_DEFAULT properly in the Palmas driver.

----------------------------------------------------------------
Dan Carpenter (1):
      pinctrl: remove an unnecessary cast

Laxman Dewangan (1):
      pinctrl: palmas: do not abort pin configuration for BIAS_DEFAULT

Mateusz Krawczuk (1):
      pinctrl: Correct number of pins for s5pv210

Thierry Reding (1):
      pinctrl: tegra114: Remove MODULE_ALIAS

Vincent Stehlé (1):
      pinctrl: fix pinconf_dbg_config_write return type

 drivers/pinctrl/pinconf.c          |  4 ++--
 drivers/pinctrl/pinctrl-exynos.c   | 12 ++++++------
 drivers/pinctrl/pinctrl-palmas.c   |  5 +++--
 drivers/pinctrl/pinctrl-tegra114.c |  5 ++---
 4 files changed, 13 insertions(+), 13 deletions(-)
