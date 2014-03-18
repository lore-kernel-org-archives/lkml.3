Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaCRCj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 22:39:57 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:34449 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753287AbaCRCj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 22:39:56 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux@maxim.org.za>, <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <wenyou.yang@atmel.com>
Subject: [PATCH 0/3] ARM: at91: add enter standby mode for ARMv7
Date: Tue, 18 Mar 2014 10:33:54 +0800
Message-ID: <1395110037-23151-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

The patches is to add support to enter standby mode for ARMv7,
then enabling the feature to disable main oscillator
when suspending to memory for sama5d3x.

The patches is based on branch, for-next and at91/cleanup
git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git

Best Regards,
Wenyou Yang

Wenyou Yang (3):
  ARM: at91: pm: add the socs support the DDRC controller
  ARM: at91: pm_slowclock: add enter standby mode for ARMv7
  defconfig: arm: sama5_defconfig: update

 arch/arm/configs/sama5_defconfig  |    1 +
 arch/arm/mach-at91/pm.c           |    5 ++++-
 arch/arm/mach-at91/pm_slowclock.S |   16 +++++++++++++++-
 3 files changed, 20 insertions(+), 2 deletions(-)

-- 
1.7.9.5

