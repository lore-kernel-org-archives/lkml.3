Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaAQPZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:25:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:46736 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbaAQPYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:24:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,674,1384329600"; 
   d="scan'208";a="468301092"
From: David Cohen <david.a.cohen@linux.intel.com>
To: linus.walleij@linaro.org, gnurou@gmail.com
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v2] gpio: intel-mid: comments cleanup
Date: Fri, 17 Jan 2014 07:30:01 -0800
Message-Id: <1389972601-27164-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389917951-13100-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1389917951-13100-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a simple cleanup on gpio-intel-mid.c's header comments.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/gpio/gpio-intel-mid.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-intel-mid.c b/drivers/gpio/gpio-intel-mid.c
index be803af658ac..41218e93b9fe 100644
--- a/drivers/gpio/gpio-intel-mid.c
+++ b/drivers/gpio/gpio-intel-mid.c
@@ -1,7 +1,7 @@
 /*
- * Moorestown platform Langwell chip GPIO driver
+ * Intel MID GPIO driver
  *
- * Copyright (c) 2008, 2009, 2013, Intel Corporation.
+ * Copyright (c) 2014 Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -11,10 +11,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 /* Supports:
-- 
1.8.4.2

