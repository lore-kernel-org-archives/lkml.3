Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab3FFF3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 01:29:50 -0400
Received: from nskntmtas04p.mx.bigpond.com ([61.9.168.146]:45903 "EHLO
	nskntmtas04p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670Ab3FFF3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 01:29:49 -0400
X-Authority-Analysis: v=2.0 cv=FNSZNpUs c=1 sm=1
 a=tpHzvNDyw14p4wpd1xf5Bw==:17 a=hcL0yXZxyVYA:10 a=aFTPlZ8mLXYA:10
 a=abLpnCq0AAAA:8 a=H5rnqBSDAAAA:8 a=YHs6QXYjAiwA:10 a=VwQbUJbxAAAA:8
 a=-cu4q2W9Il6JQi-XGMgA:9 a=tpHzvNDyw14p4wpd1xf5Bw==:117
Date: Thu, 6 Jun 2013 15:30:38 +1000
From: Greg Ungerer <gerg@uclinux.org>
Message-Id: <201306060530.r565UceA013254@goober.accelcon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-m68k@vger.kernel.org>,
        <uclinux-dev@uclinux.org>, <geert@linux-m68k.org>
Subject: [git pull] m68knommu follow up fixes for 3.10
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull the m68knommu git tree, for-linus branch.

It contains only a single fix for compilation breakage to many of the
ColdFire CPU targets.

Regards
Greg



The following changes since commit e4aa937ec75df0eea0bee03bffa3303ad36c986b:

  Linux 3.10-rc3 (2013-05-26 16:00:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

for you to fetch changes up to cf6c31fc5c3de225348742c95cc6185fca20a2f2:

  m68k: only use local gpio_request_one if not using GPIOLIB (2013-05-29 16:56:45 +1000)

----------------------------------------------------------------
Greg Ungerer (1):
      m68k: only use local gpio_request_one if not using GPIOLIB

 arch/m68k/include/asm/gpio.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
