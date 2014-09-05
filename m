Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbaIEIl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:41:27 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:52774 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaIEIlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:41:24 -0400
MIME-Version: 1.0
Date: Fri, 5 Sep 2014 10:41:24 +0200
Message-ID: <CACRpkdZ0m1D5pnZaH9yJLKHLu_Npd9KDZTUyrp5RHC3SduvAYw@mail.gmail.com>
Subject: [GIT PULL] GPIO fixes for the v3.17 series
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

again there are some GPIO fixes for v3.17. The details are in
the tag.

Please pull it in!


The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.17-3

for you to fetch changes up to 0dbc8b7afef6e4fddcfebcbacbeb269a0a3b06d5:

  gpio: move varargs hack outside #ifdef GPIOLIB (2014-09-02 10:09:43 +0200)

----------------------------------------------------------------
GPIO fixes for the v3.17 series:

- Some documentation sync
- Resource leak in the bt8xx driver
- Again fix the way varargs are used to handle the
  optional flags on the gpiod_* accessors. Now hopefully
  nailed the entire problem.

----------------------------------------------------------------
Alexandre Courbot (1):
      Documentation: gpio: documentation for optional getters functions

Linus Walleij (1):
      gpio: move varargs hack outside #ifdef GPIOLIB

Michael Auchter (1):
      gpio: bt8xx: fix release of managed resources

 Documentation/gpio/consumer.txt |  24 ++++++++-
 drivers/gpio/gpio-bt8xx.c       |   3 --
 include/linux/gpio/consumer.h   | 105 +++++++++++++++++++++++-----------------
 3 files changed, 83 insertions(+), 49 deletions(-)
