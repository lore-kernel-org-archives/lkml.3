Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaDWLjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:39:51 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:58379 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaDWLjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:39:46 -0400
Date: Wed, 23 Apr 2014 12:39:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regulator: First pull of MFD <-> Regulator IB (v3.16)
Message-ID: <20140423113941.GL21613@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:

  Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git ib-mfd-regulator-3.16

for you to fetch changes up to 60e91b51b515b20f85697fcd397911fdb97bbdca:

  regulator: tps65090: Allow setting the overcurrent wait time (2014-04-23 12:34:01 +0100)

----------------------------------------------------------------
Immutable branch between MFD and Regulator due for v3.16 merge-window.

----------------------------------------------------------------
Doug Anderson (3):
      mfd: tps65090: Don't tell child devices we have an IRQ if we don't
      mfd: tps65090: Stop caching most registers
      regulator: tps65090: Allow setting the overcurrent wait time

 Documentation/devicetree/bindings/regulator/tps65090.txt |  4 ++++
 drivers/mfd/tps65090.c                                   | 41 +++++++++++++++++++++++++----------------
 drivers/power/tps65090-charger.c                         | 11 -----------
 drivers/regulator/tps65090-regulator.c                   | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/tps65090.h                             | 19 +++++++++++++++++++
 5 files changed, 104 insertions(+), 27 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
