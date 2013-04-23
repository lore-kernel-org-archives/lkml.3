Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab3DWPzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:55:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52339 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab3DWPzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:55:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Christian Daudt <csd@broadcom.com>, Dom Cobley <popcornmix@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        John Stultz <john.stultz@linaro.org>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Matt Mackall <mpm@selenic.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Per FORLIN <per.forlin@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Shawn Guo <shawn.guo@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, alsa-devel@alsa-project.org,
        linux-rpi-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>
Subject: [PATCH] ARM: allmodconfig regressions in linux-next
Date: Tue, 23 Apr 2013 17:54:31 +0200
Message-Id: <1366732475-479886-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:2hjtr4xHv5mHEIxXVpdcSojmJD1BWeE91TNnf8/sEjf
 ATCRVseWd6PtZsLgsdxmCKzNF7ATZCKIXUtffKskWVHH+TGU3R
 SHoP2gihMt3EWAkMD/iB9YxRUYA4wF3RC8/r9oaze3rzhRAxMa
 jp0EGdw6zffCOTqXwQkXJLw3NQVhWxbqIhAlQhrn/Y6P0vcIKH
 rr9J4GXHYGIPBpug4PEpLnXg4Xkt6CeB58o0NQcUo5USSs8fS0
 1jYeOI213l+pU8VRJuRlFlZ43sy8+PQnqwwGRBdlGRmsgcNTV7
 uuJoko6+/o8KmJ8WrDhy/F3Nxt99Wx09rBk9CPa+gOOU5ILCp2
 RCYD0DqzKKXUvH+TL1GbMk06jQeOAbYuZMGE7WTKN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

These are a couple of simple patches to fix bugs that break allyesconfig
and that are only present in linux-next at the moment. Please apply
to the appropriate trees or provide feedback!

Arnd Bergmann (5):
  mfd: ab8500: remove broken ab8500_debug_register_interrupt logic
  usb: phy: phy core cannot yet be a module
  ASoC: don't call of_dma_request_slave_channel directly
  hwrng: bcm2835: fix MODULE_LICENSE tag
  clocksource: kona: adapt to CLOCKSOURCE_OF_DECLARE change

 drivers/char/hw_random/bcm2835-rng.c  |  2 +-
 drivers/clocksource/bcm_kona_timer.c  | 15 ++++-----------
 drivers/mfd/ab8500-debugfs.c          | 10 ----------
 drivers/usb/phy/Kconfig               |  2 +-
 sound/soc/soc-generic-dmaengine-pcm.c |  9 +++++----
 5 files changed, 11 insertions(+), 27 deletions(-)

Cc: Christian Daudt <csd@broadcom.com>
Cc: Dom Cobley <popcornmix@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Jonas ABERG <jonas.aberg@stericsson.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Lubomir Rintel <lkundrak@v3.sk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Mattias WALLIN <mattias.wallin@stericsson.com>
Cc: Per FORLIN <per.forlin@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: alsa-devel@alsa-project.org
Cc: linux-rpi-kernel@lists.infradead.org
Cc: linux-usb@vger.kernel.org
Cc: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
-- 
1.8.1.2

