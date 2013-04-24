Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab3DXUyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 16:54:53 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:38995 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757759Ab3DXUyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 16:54:52 -0400
MIME-Version: 1.0
Date: Wed, 24 Apr 2013 22:54:51 +0200
Message-ID: <CACRpkdZHE9pNBtKUD80=FtiePWLJpMwUMF13e_Q6ZR0Bq0iGqw@mail.gmail.com>
Subject: [GIT PULL] last minute GPIO fix for v3.9
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>,
        Mike Dunn <mikedunn@newsguy.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a last minute revert from the GPIO tree. Description in the
tag, avoids us having to push it through -stable.

Please pull it in!

Yours,
Linus Walleij


The following changes since commit 60d509fa6a9c4653a86ad830e4c4b30360b23f0e:

  Linux 3.9-rc8 (2013-04-21 14:38:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.9-lastminute

for you to fetch changes up to cf3fa17c2003dd9d1534e7da2d462132e1b70811:

  Revert "gpio: pxa: set initcall level to module init" (2013-04-24
21:42:24 +0200)

----------------------------------------------------------------
This is a last minute revert for the GPIO tree, as Mike
Dunn noticed breakage on some older PXA machines due to
moving PXA GPIO initcalls to the module_init initlevel.

----------------------------------------------------------------
Linus Walleij (1):
      Revert "gpio: pxa: set initcall level to module init"

 drivers/gpio/gpio-pxa.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)
