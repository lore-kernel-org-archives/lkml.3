Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934571Ab3DKRTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:19:40 -0400
Received: from mail-ia0-f169.google.com ([209.85.210.169]:49785 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab3DKRTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:19:39 -0400
MIME-Version: 1.0
Date: Thu, 11 Apr 2013 19:19:39 +0200
Message-ID: <CACRpkdY5yaxfqy029-bdCVSMoR-A7E7X+wX54uiyN+AS5oL-TQ@mail.gmail.com>
Subject: [GIT PULL] GPIO fix for v3.9
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a single oneliner GPIO fix for the v3.9 series arriving late.

Please pull it in.

Yours,
Linus Walleij


The following changes since commit 31880c37c11e28cb81c70757e38392b42e695dc6:

  Linux 3.9-rc6 (2013-04-07 20:49:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-fixes-v3.9-rc6

for you to fetch changes up to e7a7f972f9120a7985d38a2be8c540047c94392f:

  gpio: pca953x: fix irq_domain_add_simple usage (2013-04-11 19:01:19 +0200)

----------------------------------------------------------------
Oneliner fix for the PCA 953x driver.

----------------------------------------------------------------
Alexandre Belloni (1):
      gpio: pca953x: fix irq_domain_add_simple usage

 drivers/gpio/gpio-pca953x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
