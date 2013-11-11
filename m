Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab3KKJZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 04:25:51 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33857 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3KKJZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 04:25:43 -0500
Date: Mon, 11 Nov 2013 09:25:37 +0000
From: Lee Jones <lee.jones@linaro.org>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] [Final] MFD patches due for v3.13
Message-ID: <20131111092537.GA22184@lee--X1>
References: <20131023153510.GF2620@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131023153510.GF2620@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

Last one for v3.13.

The following changes since commit 6bfd1e63de34a278d67db32e3644340838308252:

  mfd: lpc_sch: Ignore resource conflicts when adding mfd cells (2013-10-23 16:22:40 +0100)

are available in the git repository at:

  git://git.linaro.org/people/ljones/mfd.git tags/mfd-lee-3.13-2

for you to fetch changes up to 883149b624f19ad78b84ab4403c5a32c37c033b2:

  Documentation: mfd: Update s2mps11.txt (2013-11-11 09:09:06 +0000)

----------------------------------------------------------------
mfd-lee-3.13-2

MFD patches due for v3.13.
----------------------------------------------------------------
Charles Keepax (3):
      extcon: arizona: Add defines for microphone detection levels
      extcon: arizona: Fix reset of HPDET after race with removal
      mfd: wm5110: Enable micd clamp functionality

Dan Carpenter (1):
      mfd: pm8921: Potential NULL dereference in pm8921_remove()

Geert Uytterhoeven (2):
      mfd: Stop setting refcounting pointers in original mfd_cell arrays
      mfd: Fix memory leak in mfd_add_devices()

Sachin Kamat (1):
      Documentation: mfd: Update s2mps11.txt

 Documentation/devicetree/bindings/mfd/s2mps11.txt | 13 +++++++------
 drivers/extcon/extcon-arizona.c                   | 31 +++++++++++++++++++++++++------
 drivers/mfd/mfd-core.c                            | 29 +++++++++++++++++------------
 drivers/mfd/pm8921-core.c                         |  9 +++++----
 drivers/mfd/wm5110-tables.c                       |  8 ++++++++
 include/linux/mfd/arizona/registers.h             |  9 +++++++++
 include/linux/mfd/core.h                          |  2 +-
 7 files changed, 72 insertions(+), 29 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
