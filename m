Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab3IBKak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 06:30:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:7573 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937Ab3IBKaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 06:30:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1006,1367996400"; 
   d="scan'208";a="354790385"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/3] mei: few more reset recursion fixes
Date: Mon,  2 Sep 2013 13:29:44 +0300
Message-Id: <1378117787-11528-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*** BLURB HERE ***

Alexander Usyskin (1):
  mei: cancel stall timers in mei_reset

Tomas Winkler (2):
  mei: make me client counters less error prone
  mei: bus: stop wait for read during cl state transition

 drivers/misc/mei/amthif.c  |  1 +
 drivers/misc/mei/bus.c     |  5 ++++-
 drivers/misc/mei/client.h  |  6 ++++++
 drivers/misc/mei/hbm.c     | 10 ++++++----
 drivers/misc/mei/init.c    |  3 +++
 drivers/misc/mei/main.c    | 11 ++++-------
 drivers/misc/mei/mei_dev.h |  6 +++---
 7 files changed, 27 insertions(+), 15 deletions(-)

-- 
1.8.3.1

