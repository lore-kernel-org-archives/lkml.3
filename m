Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaIYHNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:13:42 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61876 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbaIYHNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:13:40 -0400
MIME-Version: 1.0
Date: Thu, 25 Sep 2014 09:13:40 +0200
Message-ID: <CACRpkdY+QryWtpvAWFF_0Ev0rgiJvhOvwkZexsnp5wPY4y0jow@mail.gmail.com>
Subject: [GIT PULL] GPIO fixes for the v3.17 series
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are two last minute GPIO fixes for the v3.17 series, as it happens
both also set to go into stable.

Please pull them in!

Yours,
Linus Walleij

The following changes since commit 0f33be009b89d2268e94194dc4fd01a7851b6d51:

  Linux 3.17-rc6 (2014-09-21 15:43:02 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.17-4

for you to fetch changes up to 324b0398781e7afb846378dd2d8a4374faaf236b:

  gpio: Fix potential NULL handler data in chained irqchip handler
(2014-09-24 09:47:20 +0200)

----------------------------------------------------------------
Two GPIO fixes:
- GPIO direction flags where handled wrong in the new
  descriptor-based API, so direction changes did not always
  "take".
- Fix a handler installation race in the generic GPIO
  irqchip code.

----------------------------------------------------------------
Adrian Hunter (1):
      gpio: Fix gpio direction flags not getting set

Jarkko Nikula (1):
      gpio: Fix potential NULL handler data in chained irqchip handler

 drivers/gpio/gpiolib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
