Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaCRIVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:21:35 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37400 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbaCRIVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:21:31 -0400
Date: Tue, 18 Mar 2014 08:21:26 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-iio@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>, Marek Belisko <marek@goldelico.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, sre@debian.org
Subject: [GIT PULL] mfd: Immutable branch for Sebastian Reichel's work on
 mfd->io driver conversion
Message-ID: <20140318082126.GA25478@lee--X1>
References: <1394934211-21605-1-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394934211-21605-1-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:

  Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git ib-mfd-io-3.15

for you to fetch changes up to b2931b98cebfb30d940f248d2054b5268eae87a4:

  mfd: twl4030-madc: Move driver to drivers/iio/adc (2014-03-18 08:16:20 +0000)

----------------------------------------------------------------
Sebastian Reichel (7):
      mfd: twl4030-madc: Use managed resources
      mfd: twl4030-madc: Add DT support and convert to IIO framework
      mfd: twl4030-madc: Cleanup driver
      mfd: twl-core: Add twl_i2c_read/write_u16
      mfd: twl4030-madc: Use twl_i2c_read/write_u16 for 16 bit registers
      Documentation: DT: Document twl4030-madc binding
      mfd: twl4030-madc: Move driver to drivers/iio/adc

 Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt |  24 +++++++++
 drivers/iio/adc/Kconfig                                    |  10 ++++
 drivers/iio/adc/Makefile                                   |   1 +
 drivers/{mfd => iio/adc}/twl4030-madc.c                    | 320 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------
 drivers/mfd/Kconfig                                        |  10 ----
 drivers/mfd/Makefile                                       |   1 -
 include/linux/i2c/twl.h                                    |  12 +++++
 include/linux/i2c/twl4030-madc.h                           |   2 +-
 8 files changed, 247 insertions(+), 133 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt
 rename drivers/{mfd => iio/adc}/twl4030-madc.c (74%)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
