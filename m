Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab3DMHrt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 03:47:49 -0400
Received: from nschwmtas05p.mx.bigpond.com ([61.9.189.149]:62904 "EHLO
	nschwmtas05p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482Ab3DMHrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 03:47:48 -0400
X-Authority-Analysis: v=2.0 cv=dewCLAre c=1 sm=1
 a=tpHzvNDyw14p4wpd1xf5Bw==:17 a=4QTP58DfdrcA:10 a=aFTPlZ8mLXYA:10
 a=abLpnCq0AAAA:8 a=H5rnqBSDAAAA:8 a=YvqQfTbJdaQA:10 a=VwQbUJbxAAAA:8
 a=p1sYokqygRnY_oQe4BYA:9 a=tpHzvNDyw14p4wpd1xf5Bw==:117
Date: Sat, 13 Apr 2013 17:45:46 +1000
From: Greg Ungerer <gerg@uclinux.org>
Message-Id: <201304130745.r3D7jkPf013634@goober.accelcon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-m68k@vger.kernel.org>,
        <uclinux-dev@uclinux.org>, <geert@linux-m68k.org>
Subject: [git pull] m68knommu arch fixes for 3.9
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull the m68knommu git tree, for-linus branch.

It contains only a single compilation fix for ColdFire m68k targets
that use local non-GPIOLIB support.

Regards
Greg



The following changes since commit 31880c37c11e28cb81c70757e38392b42e695dc6:

  Linux 3.9-rc6 (2013-04-07 20:49:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

for you to fetch changes up to b2dfaa8d33cee9dd4ed78979f5d70063df546101:

  m68k: define a local gpio_request_one() function (2013-04-09 15:15:31 +1000)

----------------------------------------------------------------
Greg Ungerer (1):
      m68k: define a local gpio_request_one() function

 arch/m68k/include/asm/gpio.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
