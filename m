Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab3FHVWM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 17:22:12 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:52749 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab3FHVWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 17:22:11 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 8 Jun 2013 22:21:50 +0100
X-Google-Sender-Auth: 4qCAlpaCwKTiDWKAQYz73t5_xYw
Message-ID: <CACxGe6vB-PAQXoPjmgReovCR+iHykA4ns-Fix0XziZ3L2y9yUA@mail.gmail.com>
Subject: [GIT PULL] irqdomain bug fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following branch with irqdomain bug fixes.

Thanks,
g.

The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:

  Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)

are available in the git repository at:

  git://git.secretlab.ca/git/linux tags/irqdomain-for-linus

for you to fetch changes up to d94ea3f6d21e8b4398285516cc307c81d7374ec9:

  irqchip: Return -EPERM for reserved IRQs (2013-06-08 21:34:16 +0100)

----------------------------------------------------------------
irqdomain bug fixes for v3.10-rc4

This branch contains a set of straight forward bug fixes to the
irqdomain code and to a couple of drivers that make use of it.

----------------------------------------------------------------
Arnd Bergmann (1):
      irqdomain: export irq_domain_add_simple

Chen Gang (1):
      kernel/irq/irqdomain.c: before use 'irq_data', need check it
whether valid.

Grant Likely (1):
      irqchip: Return -EPERM for reserved IRQs

Linus Walleij (1):
      irqdomain: document the simple domain first_irq

 drivers/irqchip/irq-versatile-fpga.c | 2 +-
 drivers/irqchip/irq-vic.c            | 2 +-
 kernel/irq/irqdomain.c               | 9 +++++++--
 3 files changed, 9 insertions(+), 4 deletions(-)
