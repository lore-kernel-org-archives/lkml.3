Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968118Ab3E3KIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:08:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38902 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968064Ab3E3KIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:08:38 -0400
From: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
To: <khilman@linaro.org>, <j-keerthy@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: [PATCH v2 0/3] PM / AVS: SmartReflex: driver misc fixes
Date: Thu, 30 May 2013 13:08:33 +0300
Message-ID: <1369908516-26573-1-git-send-email-andrii.tseglytskyi@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series contain several misc fixes to SmartReflex driver:

1. disable errgen before vpbound disable. Critical fix, needed for
proper work of AVS-VP communicaton protocol.

2. disable runtime PM on driver remove. Trivial - runtime PM cleanup.

3. fix driver name. Trivial - proper DRIVER_NAME was not defined
since SmartReflex driver was introduced with initial commit.

Patches are based on:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
tag: v3.10-rc3

Verified on OMAP4430. Boot - OK. SmartReflex registers debug dump - OK

Changes in v2:
- rebased to v3.10-rc3
- minor comment update in "disable errgen before vpbound disable" patch

Andrii Tseglytskyi (2):
  PM / AVS: SmartReflex: disable runtime PM on driver remove
  PM / AVS: SmartReflex: fix driver name

Nishanth Menon (1):
  PM / AVS: SmartReflex: disable errgen before vpbound disable

 drivers/power/avs/smartreflex.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

-- 
1.7.9.5

