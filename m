Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab3IBAL5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 20:11:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:29144 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab3IBAL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 20:11:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1003,1367996400"; 
   d="scan'208";a="395354823"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 0/5] mei driver small fixes and cleanups
Date: Mon,  2 Sep 2013 03:10:59 +0300
Message-Id: <1378080664-7274-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alexander Usyskin (1):
  mei: mei_write correct checks for copy_from_user

Tomas Winkler (4):
  mei: mei_cl_link protect open_handle_count from overflow
  mei: make sure that me_clients_map big enough before copying
  mei: fix format compilation warrning on 32 bit architecture
  mei: revamp read and write length checks

 drivers/misc/mei/client.c |  6 ++++++
 drivers/misc/mei/hbm.c    |  7 +++++--
 drivers/misc/mei/main.c   | 23 +++++++++++++++++++----
 3 files changed, 30 insertions(+), 6 deletions(-)

-- 
1.8.3.1

