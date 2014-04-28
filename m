Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbaD1JMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:12:35 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:59576 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaD1JMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:12:34 -0400
Date: Mon, 28 Apr 2014 10:12:28 +0100
From: Lee Jones <lee.jones@linaro.org>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL v2] regulator: First pull of MFD <-> Regulator IB (v3.16)
Message-ID: <20140428091228.GJ6264@lee--X1>
References: <20140423113941.GL21613@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140423113941.GL21613@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the Regulator patch removed this time - as requested.

The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:

  Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/ib-mfd-regulator-3.16

for you to fetch changes up to c42ba72ec3a7a1b6aa30122931f1f4b91b601c31:

  mfd: tps65090: Stop caching most registers (2014-04-23 12:32:19 +0100)

----------------------------------------------------------------
Immutable branch between MFD and Regulator due for v3.16 merge-window.

----------------------------------------------------------------
Doug Anderson (2):
      mfd: tps65090: Don't tell child devices we have an IRQ if we don't
      mfd: tps65090: Stop caching most registers

 drivers/mfd/tps65090.c           | 41 +++++++++++++++++++++++++----------------
 drivers/power/tps65090-charger.c | 11 -----------
 include/linux/mfd/tps65090.h     | 14 ++++++++++++++
 3 files changed, 39 insertions(+), 27 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
