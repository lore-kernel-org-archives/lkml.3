Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab3DXCaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 22:30:08 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:33128 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756688Ab3DXCaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 22:30:06 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <thierry.reding@avionic-design.de>, <linux-kernel@vger.kernel.org>,
        <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V3 0/3] pwm: pxa: bug fix and device tree support
Date: Tue, 23 Apr 2013 22:23:51 -0400
Message-ID: <1366770234-5829-1-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches fix some bugs
1. pwm-pxa driver is shared by ARCH_PXA and ARCH_MMP
2. use module_platform_driver for driver register

The patches also add device tree support for pwm.

V2->V1:
  remove the redundant initialization.
  fix bug of no initialization of .of_match_table
  Use CONFIG_OF for device tree support. 
  rebase to for-next

V3->V2:
  change "mrvl,xxx" to "marvell,xxx".

Chao Xie (3):
  pwm: pxa: ARCH_MMP share same pwm driver with ARCH_PXA
  pwm: pxa: use module_platform_driver for driver register
  pwm: pxa: add device tree support

 drivers/pwm/Kconfig   |    2 +-
 drivers/pwm/pwm-pxa.c |   69 +++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 57 insertions(+), 14 deletions(-)

-- 
1.7.4.1

