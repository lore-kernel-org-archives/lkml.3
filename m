Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbaIBKpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:45:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:63068 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbaIBKpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:45:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,448,1406617200"; 
   d="scan'208";a="596688819"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 4/4] mfd: lpc_sch: remove FSF address
Date: Tue,  2 Sep 2014 13:45:22 +0300
Message-Id: <1409654722-6570-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409654722-6570-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1409654722-6570-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes FSF address because it can be changed. While here, update
the copyright lines by adding Intel Corp. to them.

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/mfd/lpc_sch.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
index ae614b2..c980da4 100644
--- a/drivers/mfd/lpc_sch.c
+++ b/drivers/mfd/lpc_sch.c
@@ -7,6 +7,7 @@
  *  Configuration Registers.
  *
  *  Copyright (c) 2010 CompuLab Ltd
+ *  Copyright (c) 2014 Intel Corp.
  *  Author: Denis Turischev <denis@compulab.co.il>
  *
  *  This program is free software; you can redistribute it and/or modify
@@ -17,10 +18,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; see the file COPYING.  If not, write to
- *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/kernel.h>
-- 
2.1.0

