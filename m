Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbaEIJzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:55:51 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38336 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaEIJzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:55:50 -0400
Date: Fri, 9 May 2014 10:55:45 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL v2] First pull-request for the IB between MFD and GPIO
Message-ID: <20140509095545.GO5767@lee--X1>
References: <1399583799-23517-1-git-send-email-linus.walleij@linaro.org>
 <20140509093111.GN5767@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140509093111.GN5767@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like it matters which order the patches are merged in - my bad!

The following changes since commit 89ca3b881987f5a4be4c5dbaa7f0df12bbdde2fd:

  Linux 3.15-rc4 (2014-05-04 18:14:42 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/ib-mfd-gpio-v3.16

for you to fetch changes up to 3ba1d516d5feddba3e13d30d31a70da130a3ee0e:

  mfd: stmpe: root out static GPIO and IRQ assignments (2014-05-09 10:51:14 +0100)

----------------------------------------------------------------
Immutable branch between MFD and GPIO due for v3.16.

----------------------------------------------------------------
Linus Walleij (4):
      mfd: stmpe: mask off unused blocks properly
      mfd: stmpe: Probe properly from the Device Tree
      mfd: stmpe: add optional regulators
      mfd: stmpe: root out static GPIO and IRQ assignments

 drivers/gpio/gpio-stmpe.c | 18 +++++-------------
 drivers/mfd/Kconfig       |  1 +
 drivers/mfd/stmpe-i2c.c   | 30 +++++++++++++++++++++++++++++-
 drivers/mfd/stmpe.c       | 30 ++++++++++++++++++++++++++++--
 drivers/mfd/stmpe.h       |  2 +-
 include/linux/mfd/stmpe.h | 19 +++++--------------
 6 files changed, 69 insertions(+), 31 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
