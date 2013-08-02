Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3HBRgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:36:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:35790 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab3HBRgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:36:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="340802315"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 00/15] NTB: Bug Fixes and New Features 
Date: Fri,  2 Aug 2013 10:35:29 -0700
Message-Id: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A fairly major update for NTB.  Numerous fixes and features being added,
including adding support for NTB-RP and using DMA engines to
transmit/receive data.  Reviews are appreciated!

Thanks,
Jon

 MAINTAINERS                 |    2 +
 drivers/ntb/Kconfig         |    2 +-
 drivers/ntb/ntb_hw.c        |  483 ++++++++++++++++++++++++++++++++++---------
 drivers/ntb/ntb_hw.h        |  105 ++++++++--
 drivers/ntb/ntb_regs.h      |   47 +++--
 drivers/ntb/ntb_transport.c |  382 ++++++++++++++++++++++++++--------
 6 files changed, 802 insertions(+), 219 deletions(-)

