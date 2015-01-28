Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbbA1Uzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:55:31 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:46983 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbbA1Uz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:55:28 -0500
MIME-Version: 1.0
Date: Wed, 28 Jan 2015 10:25:21 +0100
Message-ID: <CACRpkdZfWmO324Jk5Bv4Mi15eZ=pMiOuUzT=oOoaU150Jo6Nnw@mail.gmail.com>
Subject: [GIT PULL] final pin control fix for v3.19
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a (hopefully) final pin control fix for the v3.19 series.
This affects the AT91 driver only and is tagged for stable as
well.

Please pull it in!

Yours,
Linus Walleij

The following changes since commit 26bc420b59a38e4e6685a73345a0def461136dce:

  Linux 3.19-rc6 (2015-01-25 20:04:41 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.19-4

for you to fetch changes up to a0b957f306fa4d0a39f4ffe5e5e25e856e6be46e:

  pinctrl: at91: allow to have disabled gpio bank (2015-01-26 09:13:36 +0100)

----------------------------------------------------------------
A late pin control fix for the v3.19 series:
The AT91 gpio controller would miss wakeup events, this
single fix make it work properly.

----------------------------------------------------------------
Jean-Christophe PLAGNIOL-VILLARD (1):
      pinctrl: at91: allow to have disabled gpio bank

 drivers/pinctrl/pinctrl-at91.c | 108 +++++++++++++++++++++--------------------
 1 file changed, 55 insertions(+), 53 deletions(-)
