Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751007Ab3DNFD0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 01:03:26 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56676 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750716Ab3DNFDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 01:03:25 -0400
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Fabio Estevam <festevam@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] freescale: Update logging style
Date: Sat, 13 Apr 2013 22:03:16 -0700
Message-Id: <cover.1365915548.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert various printk logging styles to current styles.

Uncompiled, untested.

Joe Perches (3):
  fec: Convert printks to netdev_<level>
  gianfar: Use netdev_<level> when possible
  ucc_geth: Convert ugeth_<level> to pr_<level>

 drivers/net/ethernet/freescale/fec_main.c         |  26 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c      |  16 +-
 drivers/net/ethernet/freescale/fec_ptp.c          |   2 +
 drivers/net/ethernet/freescale/gianfar_ethtool.c  |  24 +-
 drivers/net/ethernet/freescale/gianfar_ptp.c      |   3 +
 drivers/net/ethernet/freescale/gianfar_sysfs.c    |   2 +-
 drivers/net/ethernet/freescale/ucc_geth.c         | 881 ++++++++++------------
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c |  24 +-
 8 files changed, 441 insertions(+), 537 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

