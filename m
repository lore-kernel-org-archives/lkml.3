Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbaHNOXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:23:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:36835 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881AbaHNOXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:23:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,863,1400050800"; 
   d="scan'208";a="576685279"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/2] mei: amthif simplifications
Date: Thu, 14 Aug 2014 17:22:19 +0300
Message-Id: <1408026141-18241-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alexander Usyskin (2):
  mei: amthif: use service function to flush amthif queue
  mei: amthif: don't check amthif client identity on amthif queues

 drivers/misc/mei/amthif.c    | 37 +++++++++++++++----------------------
 drivers/misc/mei/client.c    |  2 +-
 drivers/misc/mei/client.h    |  2 ++
 drivers/misc/mei/interrupt.c | 13 ++-----------
 4 files changed, 20 insertions(+), 34 deletions(-)

-- 
1.9.3

