Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab3HYJwM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 05:52:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:34236 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209Ab3HYJwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 05:52:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,951,1367996400"; 
   d="scan'208";a="351301653"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [3.10][PATCH 0/4] resume reset fixes for stable 3.10
Date: Sun, 25 Aug 2013 12:49:45 +0300
Message-Id: <1377424189-5508-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas Winkler (4):
  mei: me: fix reset state machine
  mei: don't have to clean the state on power up
  mei: me: fix waiting for hw ready
  mei: me: fix hardware reset flow

 drivers/misc/mei/hw-me.c | 22 +++++++++++++---------
 drivers/misc/mei/init.c  |  3 ++-
 2 files changed, 15 insertions(+), 10 deletions(-)

-- 
1.8.1.2

