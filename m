Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760786AbaEMJ4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:56:32 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:63369 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760082AbaEMJ43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:56:29 -0400
MIME-Version: 1.0
Date: Tue, 13 May 2014 11:56:28 +0200
Message-ID: <CACRpkdYM9eQxWdG8qNkzstPRuQJYc6RLVLjo5tTWcwHT43S7Cg@mail.gmail.com>
Subject: [GIT PULL] gpio fixes for v3.15
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Welling <mwelling@ieee.org>,
        Vincent Donnefort <vdonnefort@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

let's hope these two patches are the last GPIO fixes for this
merge window. (Famous last words.)

Anyway, details in the tag, please pull it in.

Yours,
Linus Walleij

The following changes since commit 89ca3b881987f5a4be4c5dbaa7f0df12bbdde2fd:

  Linux 3.15-rc4 (2014-05-04 18:14:42 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.15-3

for you to fetch changes up to 99e4b98dbe3ad1fe38a74d12c3b8d44a55930de4:

  gpio: mcp23s08: Bug fix of SPI device tree registration. (2014-05-09
10:28:16 +0200)

----------------------------------------------------------------
GPIO fixes for the v3.15 series:

- Fix a null pointer bug in the ICH6 chipset driver

- Fix device tree registration for the mcp23s08 driver

----------------------------------------------------------------
Michael Welling (1):
      gpio: mcp23s08: Bug fix of SPI device tree registration.

Vincent Donnefort (1):
      gpio: ich: set regs and reglen for i3100 and ich6 chipset

 drivers/gpio/gpio-ich.c      |  4 ++++
 drivers/gpio/gpio-mcp23s08.c | 12 +++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)
