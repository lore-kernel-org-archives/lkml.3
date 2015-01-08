Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbbAHJka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:40:30 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:47063 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbbAHJkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 04:40:07 -0500
MIME-Version: 1.0
Date: Thu, 8 Jan 2015 10:40:06 +0100
Message-ID: <CACRpkdbDOMRRVRb637por_sOuoOZHPLOR8jeB3LfSWM6mCPnwQ@mail.gmail.com>
Subject: [GIT PULL] pin control fixes, take one
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        Doug Anderson <dianders@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

allright allright I've been lazy over christmas and New Years.
Here are a few collected pin control fixes eventually, details
in the signed tag.

Please pull it in!

Yours,
Linus Walleij

The following changes since commit b7392d2247cfe6771f95d256374f1a8e6a6f48d6:

  Linux 3.19-rc2 (2014-12-28 16:49:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.19-2

for you to fetch changes up to fce7fcc785998d91a4e2293ec6c0fa7a4677999b:

  pinctrl: st: Add irq_disable hook to st_gpio_irqchip (2015-01-07
10:44:39 +0100)

----------------------------------------------------------------
A set of assorted pin control fixes for the Rockchip
and STi drivers.

----------------------------------------------------------------
Doug Anderson (2):
      pinctrl: rockchip: Handle wakeup pins
      pinctrl: rockchip: Fix enable/disable/mask/unmask

Francesco VIRLINZI (1):
      pinctrl: st: avoid multiple mutex lock

Patrice CHOTARD (1):
      pinctrl: st: Add irq_disable hook to st_gpio_irqchip

 drivers/pinctrl/pinctrl-rockchip.c | 57 ++++++++++++++++++++++++++++++++++++--
 drivers/pinctrl/pinctrl-st.c       |  5 +++-
 2 files changed, 58 insertions(+), 4 deletions(-)
