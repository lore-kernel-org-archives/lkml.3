Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaJCQta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 12:49:30 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:38887 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbaJCQt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 12:49:26 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Mark Brown <broonie@kernel.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-spi@vger.kernel.org
Subject: [PATCH v2 0/2] fsl: fsl-spi: Fix CMP1 pram allocation and allow dynamic allocation
Message-Id: <20141003164916.BA7611AAFC7@localhost.localdomain>
Date: Fri,  3 Oct 2014 18:49:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset:
1) Fix parameter ram offset setup for CPM1
2) Allow dynamic allocation of CPM1 parameter RAM

Tested on MPC885.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
Changes from v1 to v2: using OF compatible instead of compile time option

 drivers/spi/spi-fsl-cpm.c   | 12 +++++++-----
 drivers/spi/spi-fsl-lib.c   |  2 ++
 include/linux/fsl_devices.h |  1 +
 3 files changed, 10 insertions(+), 5 deletions(-)
