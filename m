Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbaFBI6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 04:58:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38640 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752309AbaFBI6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:58:18 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Arizona clean up driver removal and error paths
Date: Mon,  2 Jun 2014 09:50:38 +0100
Message-Id: <1401699043-16835-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several small fixes to the error and driver removal paths
for the arizona devices. This series will likely need to be
applied onto of my earlier "wm5110 Interrupt Updates" series
to apply cleanly, please let me know if I need to resend
that. It would also be possible to rebase them the other way
round although that will obviously require me to resend the
interrupt series.

Thanks,
Charles

Charles Keepax (5):
  mfd: arizona: Disable PM runtime at start of driver removal
  mfd: arizona: Disable DCVDD before we destroy the MFD
  mfd: arizona: Don't use devres for DCVDD
  mfd: arizona: Use num_core_supplies in arizona_dev_exit
  mfd: arizona: Lower ARIZONA_MAX_CORE_SUPPLIES to 2

 drivers/mfd/arizona-core.c       |   18 ++++++++++++------
 include/linux/mfd/arizona/core.h |    2 +-
 2 files changed, 13 insertions(+), 7 deletions(-)

-- 
1.7.2.5

