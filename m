Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaIKHas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 03:30:48 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:53062 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaIKHar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 03:30:47 -0400
MIME-Version: 1.0
Date: Thu, 11 Sep 2014 09:30:46 +0200
Message-ID: <CACRpkdYzJjsiWZPHRsnjYTnFpwWKD4W4hMktCERRp+_8oCB3+A@mail.gmail.com>
Subject: [GIT PULL] pin control fixes for the v3.17 series
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is a set of fixes for the v3.17 series, just two this time.
Details in the signed tag.

Please pull it in!

Yours,
Linus Walleij


The following changes since commit 2ce7598c9a453e0acd0e07be7be3f5eb39608ebd:

  Linux 3.17-rc4 (2014-09-07 16:09:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.17-3

for you to fetch changes up to fea685e9f9d0c3d273aa861891bf5ac952012d21:

  MAINTAINERS: Tomasz has moved (2014-09-10 14:25:51 +0200)

----------------------------------------------------------------
Two pin control fixes:
- Fix a warning about unbalanced IRQs on the Baytrail
- Update Tomasz Figa's address in MAINTAINERS

----------------------------------------------------------------
Mathias Nyman (1):
      pinctrl: baytrail: resolve unbalanced IRQ wake disable warning

Tomasz Figa (1):
      MAINTAINERS: Tomasz has moved

 MAINTAINERS                        | 5 +++--
 drivers/pinctrl/pinctrl-baytrail.c | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)
