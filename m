Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaFOAmc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 20:42:32 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:34651 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaFOAma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 20:42:30 -0400
From: Lv Zheng <zetalog@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <zetalog@gmail.com>, Lv Zheng <lv.zheng@intel.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 5/7] ACPI/EC: Update revision due to full asynchrnous command support.
Date: Sun, 15 Jun 2014 08:42:19 +0800
Message-Id: <5c2f80eca33c40538c74337044a3b40e07a137af.1402792240.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1402792240.git.lv.zheng@intel.com>
References: <cover.1402543079.git.lv.zheng@intel.com> <cover.1402792240.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lv Zheng <lv.zheng@intel.com>

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

