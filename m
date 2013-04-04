Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483Ab3DDKa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 06:30:59 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:43944 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759426Ab3DDKa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 06:30:58 -0400
MIME-Version: 1.0
Date: Thu, 4 Apr 2013 12:30:58 +0200
Message-ID: <CACRpkdYT7UOZocgbvO+=S0YoP=d0bpm-RCCiG9h=skrKinHdvQ@mail.gmail.com>
Subject: [GIT PULL] GPIO fixes for the v3.9 series
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@stericsson.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a set of two GPIO fixes for the v3.9 series. With this I
think we are finished with GPIO for this cycle, but you never
know.

Please pull it in!

Yours,
Linus Walleij


The following changes since commit a937536b868b8369b98967929045f1df54234323:

  Linux 3.9-rc3 (2013-03-17 15:59:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-fixes-v3.9

for you to fetch changes up to 9afd9b7090225d78ef56423a2ff65354dc38f1b1:

  gpio: stmpe: pass DT node to irqdomain (2013-03-27 11:21:52 +0100)

----------------------------------------------------------------
Two GPIO fixes for the v3.9 series:
- Fix erroneous return value in the ICH driver
- Make the STMPE driver proper properly on device tree boots

----------------------------------------------------------------
Gabriel Fernandez (1):
      gpio: stmpe: pass DT node to irqdomain

Jean Delvare (1):
      gpio-ich: Fix value returned by ichx_gpio_request

 drivers/gpio/gpio-ich.c   |  2 +-
 drivers/gpio/gpio-stmpe.c | 15 +++++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)
