Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935541Ab3DHS5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:57:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:55282 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935175Ab3DHS5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:57:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="224698892"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/2] mei cleanups
Date: Mon,  8 Apr 2013 21:56:36 +0300
Message-Id: <1365447398-15537-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tomas Winkler (2):
  mei: add mei_cl_write function
  mei: notify about the reset in error level

 drivers/misc/mei/bus.c       | 103 ++++++++----------------------------------
 drivers/misc/mei/client.c    | 105 +++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/client.h    |   7 ++-
 drivers/misc/mei/hbm.c       |  21 ++++-----
 drivers/misc/mei/interrupt.c |   6 +--
 drivers/misc/mei/main.c      |  83 +++++++---------------------------
 drivers/misc/mei/mei_dev.h   |   6 +--
 7 files changed, 158 insertions(+), 173 deletions(-)

-- 
1.8.1.2

