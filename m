Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbaGGIxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:53:35 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:41610 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbaGGIxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:53:33 -0400
MIME-Version: 1.0
Date: Mon, 7 Jul 2014 10:53:32 +0200
Message-ID: <CACRpkdYE2srMs0KwMbHLsOrZaprR3c=QbZhP_mqsWhDOBtTj-g@mail.gmail.com>
Subject: [GIT PULL] pin control fixes for v3.16, take one
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are two pin control fixes for v3.16. I'm a bit snowed under
by mail but these have boiled in linux-next and should propagate
to you.

Please pull them in!

Yours,
Linus Walleij

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.16-2

for you to fetch changes up to 1419d8151be990f115c38deac497ad84d26434dd:

  pinctrl: berlin: fix an error code in berlin_pinctrl_probe()
(2014-07-05 01:15:35 +0200)

----------------------------------------------------------------
Two fixes for the pin control subsystem, both relating to
the errorpath in probe().

----------------------------------------------------------------
Dan Carpenter (1):
      pinctrl: berlin: fix an error code in berlin_pinctrl_probe()

Sachin Kamat (1):
      pinctrl: sunxi: Fix potential null pointer dereference

 drivers/pinctrl/berlin/berlin.c       | 2 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)
