Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205AbaDIMCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 08:02:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42321 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542AbaDIMCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 08:02:07 -0400
Date: Wed, 9 Apr 2014 13:02:01 +0100
From: Lee Jones <lee.jones@linaro.org>
To: torvalds@linux-foundation.org
Cc: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Backlight pull-request for v3.15
Message-ID: <20140409120201.GH8888@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit fa389e220254c69ffae0d403eac4146171062d08:

  Linux 3.14-rc6 (2014-03-09 19:41:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/backlight.git tags/backlight-for-linus-3.15

for you to fetch changes up to f1740e4cffede3e919a3511bf4e5113d642f09ec:

  backlight: lm3639: Use devm_backlight_device_register() (2014-04-08 13:20:41 +0100)

----------------------------------------------------------------
 - Call put_device() instead of kfree() - core
 - Add DT support - gpio-backlight
 - Use managed resources - lm3639_bl
----------------------------------------------------------------
Daniel Jeong (1):
      backlight: lm3639: Use devm_backlight_device_register()

Denis Carikli (1):
      backlight: gpio-backlight: Add DT support

Levente Kurusa (1):
      backlight: core: Replace kfree with put_device

 Documentation/devicetree/bindings/video/backlight/gpio-backlight.txt | 16 ++++++++++++++++
 drivers/video/backlight/backlight.c                                  |  2 +-
 drivers/video/backlight/gpio_backlight.c                             | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 drivers/video/backlight/lm3639_bl.c                                  | 17 +++++++----------
 4 files changed, 75 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/video/backlight/gpio-backlight.txt

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
