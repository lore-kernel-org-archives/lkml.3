Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbaCRLJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 07:09:54 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:41926 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaCRLJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 07:09:52 -0400
Date: Tue, 18 Mar 2014 11:09:47 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, broonie@kernel.org,
        devicetree@vger.kernel.org
Subject: [GIT PULL] mfd: regulator: S2MPA01 device support IB for Mark Brown
Message-ID: <20140318110947.GR25478@lee--X1>
References: <1394797919-24642-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394797919-24642-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FAO Mark,

The following changes since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:

  Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git ib-mfd-regulator-3.15

for you to fetch changes up to ba3e31f87e8b736adf01f1dc09cd5618966ee193:

  Documentation: mfd: Add binding document for S2MPA01 (2014-03-18 10:56:45 +0000)

----------------------------------------------------------------
Krzysztof Kozlowski (5):
      mfd: sec-core: Add maximum RTC register for regmap config
      mfd: sec-core: Select different RTC regmaps for devices
      mfd: sec-irq: Use consistent S2MPS11 RTC alarm interrupt indexes
      mfd: sec: Add support for S2MPS14
      mfd: sec-core: Fix possible NULL pointer dereference when i2c_new_dummy error

Pankaj Dubey (1):
      mfd: sec-core: Silence compiler warning

Sachin Kamat (3):
      mfd: Add support for S2MPA01 device
      regulator: Add support for S2MPA01 regulator
      Documentation: mfd: Add binding document for S2MPA01

 Documentation/devicetree/bindings/mfd/s2mpa01.txt |  90 ++++++++++++++++++++++++++
 drivers/mfd/sec-core.c                            | 112 +++++++++++++++++++++++++++++---
 drivers/mfd/sec-irq.c                             |  97 ++++++++++++++++++++++++++--
 drivers/regulator/Kconfig                         |   7 ++
 drivers/regulator/Makefile                        |   1 +
 drivers/regulator/s2mpa01.c                       | 481 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/samsung/core.h                  |  19 ++++--
 include/linux/mfd/samsung/irq.h                   |  81 +++++++++++++++++++++++-
 include/linux/mfd/samsung/rtc.h                   |  57 +++++++++++++++--
 include/linux/mfd/samsung/s2mpa01.h               | 192 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/samsung/s2mps14.h               | 152 ++++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 1260 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/s2mpa01.txt
 create mode 100644 drivers/regulator/s2mpa01.c
 create mode 100644 include/linux/mfd/samsung/s2mpa01.h
 create mode 100644 include/linux/mfd/samsung/s2mps14.h

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
