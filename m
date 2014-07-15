Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbaGOTLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:11:09 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:56357 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850AbaGOTLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:11:07 -0400
MIME-Version: 1.0
Date: Tue, 15 Jul 2014 21:04:25 +0200
Message-ID: <CACRpkdbX6w5+S2pqomMAG4zV6o-Qs5dxLzS-4Z30BBC3KNZ=qA@mail.gmail.com>
Subject: [GIT PULL] GPIO fix for v3.16
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a single GPIO fix for the v3.16 series, I haven't had much more
noise in GPIO this time so I hope this is the last pull request for
this cycle. (Famous last words.)

Please pull it in!

Yours,
Linus Walleij

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.16-3

for you to fetch changes up to ef8290ac727b1718417a781412fb6c25e97b5389:

  gpio: mcp23s08: Eliminates redundant checking. (2014-07-05 01:14:06 +0200)

----------------------------------------------------------------
A GPIO fix for the v3.16 series - fixes up some merge
confusion from the merge window.

----------------------------------------------------------------
Michael Welling (1):
      gpio: mcp23s08: Eliminates redundant checking.

 drivers/gpio/gpio-mcp23s08.c | 6 ------
 1 file changed, 6 deletions(-)
