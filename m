Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaKLTnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 14:43:33 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:53117 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaKLTnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 14:43:32 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.18-rc5
Date: Wed, 12 Nov 2014 11:43:26 -0800
Message-Id: <1415821406-18384-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.5463B863.02DC,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon fixes for Linux 3.18-rc5 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus-v3.18-rc5

Thanks,
Guenter
------

The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:

  Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus-v3.18-rc5

for you to fetch changes up to 0bd52941586b3b59ab9b6e89e55b2dc9e2680de9:

  hwmon: (fam15h_power) Fix NB device ID for F16h M30h (2014-11-11 10:39:45 -0800)

----------------------------------------------------------------
Fix PCI device ID in fam15h_power driver
Fix suspend/resume behavior in pwm-fan driver
Reduce logging noise created by ibmpowernv driver

----------------------------------------------------------------
Aravind Gopalakrishnan (1):
      hwmon: (fam15h_power) Fix NB device ID for F16h M30h

Kamil Debski (1):
      hwmon: (pwm-fan) Fix suspend/resume behavior

Michael Ellerman (1):
      hwmon: (ibmpowernv) Quieten when probing finds no device

 drivers/hwmon/fam15h_power.c |  2 +-
 drivers/hwmon/ibmpowernv.c   |  6 ++++--
 drivers/hwmon/pwm-fan.c      | 13 ++++++++++---
 3 files changed, 15 insertions(+), 6 deletions(-)
