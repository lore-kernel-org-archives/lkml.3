Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab3HBRhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:37:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:8328 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab3HBRhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:37:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="380903468"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 15/15] MAINTAINERS: Add Website and Git Tree for NTB
Date: Fri,  2 Aug 2013 10:35:44 -0700
Message-Id: <1375464944-27914-16-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
References: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add website and git tree for the NTB entry in MAINTAINERS

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ad7e322..821f468 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5741,6 +5741,8 @@ F:	drivers/scsi/nsp32*
 NTB DRIVER
 M:	Jon Mason <jon.mason@intel.com>
 S:	Supported
+W:	https://github.com/jonmason/ntb/wiki
+T:	git git://github.com/jonmason/ntb.git
 F:	drivers/ntb/
 F:	drivers/net/ntb_netdev.c
 F:	include/linux/ntb.h
-- 
1.7.9.5

