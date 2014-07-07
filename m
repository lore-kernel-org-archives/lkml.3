Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaGGDKt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 23:10:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:14754 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbaGGDKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 23:10:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,615,1400050800"; 
   d="scan'208";a="565965238"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [UPDATE PATCH v2 5/6] ACPI/EC: Update revision due to full asynchrnous command support.
Date: Mon,  7 Jul 2014 11:10:27 +0800
Message-Id: <e7a06df488fc6da13fec6da52ef91eee41ef907b.1404700569.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1404700569.git.lv.zheng@intel.com>
References: <cover.1402792240.git.lv.zheng@intel.com> <cover.1404700569.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bug fixes and asynchronous improvements have been done to the EC driver
by the previous commits. This patch increases the revision to 2.2 to
indicate the behavior differences between the old and the new drivers. The
copyright/authorship notices are also updated.

Authorship of Alexey is updated according to the following diff block:
  - *  ec.c - ACPI Embedded Controller Driver (v2.0)
  + *  ec.c - ACPI Embedded Controller Driver (v2.1)
  - *  Copyright (C) 2006, 2007 Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
  + *  Copyright (C) 2006-2008 Alexey Starikovskiy <astarikovskiy@suse.de>
This change is made by the following commit:
  Commit: 7c6db4e050601f359081fde418ca6dc4fc2d0011
  Subject: ACPI: EC: do transaction from interrupt context

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 49d8990..051ac47 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1,11 +1,14 @@
 /*
- *  ec.c - ACPI Embedded Controller Driver (v2.1)
+ *  ec.c - ACPI Embedded Controller Driver (v2.2)
  *
- *  Copyright (C) 2006-2008 Alexey Starikovskiy <astarikovskiy@suse.de>
- *  Copyright (C) 2006 Denis Sadykov <denis.m.sadykov@intel.com>
- *  Copyright (C) 2004 Luming Yu <luming.yu@intel.com>
- *  Copyright (C) 2001, 2002 Andy Grover <andrew.grover@intel.com>
- *  Copyright (C) 2001, 2002 Paul Diefenbaugh <paul.s.diefenbaugh@intel.com>
+ *  Copyright (C) 2001-2014 Intel Corporation
+ *    Auther: 2014       Lv Zheng <lv.zheng@intel.com>
+ *            2006, 2007 Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
+ *            2006       Denis Sadykov <denis.m.sadykov@intel.com>
+ *            2004       Luming Yu <luming.yu@intel.com>
+ *            2001, 2002 Andy Grover <andrew.grover@intel.com>
+ *            2001, 2002 Paul Diefenbaugh <paul.s.diefenbaugh@intel.com>
+ *  Copyright (C) 2008      Alexey Starikovskiy <astarikovskiy@suse.de>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *
-- 
1.7.10

