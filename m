Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbbATNCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:02:47 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:56313 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbbATNCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:02:45 -0500
Date: Tue, 20 Jan 2015 13:02:32 +0000
From: Lee Jones <lee.jones@linaro.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] MFD fixes for v3.19
Message-ID: <20150120130232.GF13701@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit b7392d2247cfe6771f95d256374f1a8e6a6f48d6:

  Linux 3.19-rc2 (2014-12-28 16:49:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-fixes-3.19

for you to fetch changes up to b166010f6afbadb896efa37ff85eb681a8f89392:

  mfd: rtsx_usb: Fix runtime PM deadlock (2015-01-20 12:52:55 +0000)

----------------------------------------------------------------
 - Avoid platform ID collision in da9052
 - Skip caching volatile registers in tps65218
 - Use correct address base in tps65218
 - Repair deadlock on suspend in rtsx_usb

----------------------------------------------------------------
Fabio Estevam (1):
      mfd: da9052-core: Fix platform-device id collision

Felipe Balbi (2):
      mfd: tps65218: Make INT[12] and STATUS registers volatile
      mfd: tps65218: Make INT1 our status_base register

Roger Tseng (1):
      mfd: rtsx_usb: Fix runtime PM deadlock

 drivers/mfd/da9052-core.c |  3 ++-
 drivers/mfd/rtsx_usb.c    | 12 ------------
 drivers/mfd/tps65218.c    | 12 ++++++++++++
 3 files changed, 14 insertions(+), 13 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
