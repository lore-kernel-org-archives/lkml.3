Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbaHVK6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 06:58:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:16318 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756068AbaHVK62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 06:58:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,379,1406617200"; 
   d="scan'208";a="588467227"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 5/5] mfd: lpc_sch: remove FSF address
Date: Fri, 22 Aug 2014 13:58:16 +0300
Message-Id: <1408705096-31286-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408705096-31286-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408705096-31286-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes FSF address becase it can be changed. While here, update the
copyright lines by adding Intel Corp. to them.

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/mfd/lpc_sch.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
index 6145a4c..b14ca7c 100644
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

