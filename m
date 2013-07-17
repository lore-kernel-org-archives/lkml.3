Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab3GQMOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:14:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:55706 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab3GQMOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:14:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,684,1367996400"; 
   d="scan'208";a="346987171"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 0/4 3.11] Fix mei suspend/resume failure
Date: Wed, 17 Jul 2013 15:13:13 +0300
Message-Id: <1374063197-26855-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series should fix the long standing reset storm
issue in mei suspend/resume failure

The issue was reported in few places:
https://lkml.org/lkml/2013/6/26/693
https://lkml.org/lkml/2013/7/14/69


Tomas Winkler (4):
  mei: hbm: fix typo in error message
  mei: me: fix reset state machine
  mei: don't have to clean the state on power up
  mei: me: fix waiting for hw ready

 drivers/misc/mei/hbm.c   |  2 +-
 drivers/misc/mei/hw-me.c | 14 ++++++++++----
 drivers/misc/mei/init.c  |  3 ++-
 3 files changed, 13 insertions(+), 6 deletions(-)

-- 
1.8.1.2

