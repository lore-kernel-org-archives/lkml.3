Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab3E0LHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 07:07:30 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49019 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757603Ab3E0LH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 07:07:29 -0400
From: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
To: Kevin Hilman <khilman@linaro.org>, J Keerthy <j-keerthy@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH v1 0/3] PM / AVS: SmartReflex: driver misc fixes
Date: Mon, 27 May 2013 14:07:23 +0300
Message-ID: <1369652846-14412-1-git-send-email-andrii.tseglytskyi@ti.com>
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
tag: v3.10-rc2

Verified on OMAP4430. Boot - OK. SmartReflex registers debug dump - OK

Available on GitHub:
https://github.com/andriit/linux-omap-k3.8/commits/avs_sr_driver_misc_fixes_v01

Andrii Tseglytskyi (2):
  PM / AVS: SmartReflex: disable runtime PM on driver remove
  PM / AVS: SmartReflex: fix driver name

Nishanth Menon (1):
  PM / AVS: SmartReflex: disable errgen before vpbound disable

 drivers/power/avs/smartreflex.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

-- 
1.7.9.5

