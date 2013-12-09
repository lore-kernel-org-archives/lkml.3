Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909Ab3LIJcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:32:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:61071 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab3LIJci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:32:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,856,1378882800"; 
   d="scan'208";a="421561449"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Alex Courbot <acourbot@nvidia.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] SFI: remove wrong FSF address from the license
Date: Mon,  9 Dec 2013 11:32:07 +0200
Message-Id: <1386581527-28907-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove old and currently wrong address of the FSF from license parts of the
code.

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/sfi/sfi_acpi.c   | 6 ------
 drivers/sfi/sfi_core.c   | 6 ------
 drivers/sfi/sfi_core.h   | 6 ------
 include/linux/sfi.h      | 6 ------
 include/linux/sfi_acpi.h | 6 ------
 5 files changed, 30 deletions(-)

diff --git a/drivers/sfi/sfi_acpi.c b/drivers/sfi/sfi_acpi.c
index d4dfcbe..0c5a29a 100644
--- a/drivers/sfi/sfi_acpi.c
+++ b/drivers/sfi/sfi_acpi.c
@@ -18,12 +18,6 @@
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.
 
-  You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
-  The full GNU General Public License is included in this distribution
-  in the file called LICENSE.GPL.
-
   BSD LICENSE
 
   Copyright(c) 2009 Intel Corporation. All rights reserved.
diff --git a/drivers/sfi/sfi_core.c b/drivers/sfi/sfi_core.c
index e9ff6f0..bd01928 100644
--- a/drivers/sfi/sfi_core.c
+++ b/drivers/sfi/sfi_core.c
@@ -18,12 +18,6 @@
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.
 
-  You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
-  The full GNU General Public License is included in this distribution
-  in the file called LICENSE.GPL.
-
   BSD LICENSE
 
   Copyright(c) 2009 Intel Corporation. All rights reserved.
diff --git a/drivers/sfi/sfi_core.h b/drivers/sfi/sfi_core.h
index 18c663d..15f85bc 100644
--- a/drivers/sfi/sfi_core.h
+++ b/drivers/sfi/sfi_core.h
@@ -18,12 +18,6 @@
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.
 
-  You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
-  The full GNU General Public License is included in this distribution
-  in the file called LICENSE.GPL.
-
   BSD LICENSE
 
   Copyright(c) 2009 Intel Corporation. All rights reserved.
diff --git a/include/linux/sfi.h b/include/linux/sfi.h
index 510e74d..2a5cfa7 100644
--- a/include/linux/sfi.h
+++ b/include/linux/sfi.h
@@ -18,12 +18,6 @@
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.
 
-  You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
-  The full GNU General Public License is included in this distribution
-  in the file called LICENSE.GPL.
-
   BSD LICENSE
 
   Copyright(c) 2009 Intel Corporation. All rights reserved.
diff --git a/include/linux/sfi_acpi.h b/include/linux/sfi_acpi.h
index ecc2344..1cc1b5e 100644
--- a/include/linux/sfi_acpi.h
+++ b/include/linux/sfi_acpi.h
@@ -18,12 +18,6 @@
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.
 
-  You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software
-  Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
-  The full GNU General Public License is included in this distribution
-  in the file called LICENSE.GPL.
-
   BSD LICENSE
 
   Copyright(c) 2009 Intel Corporation. All rights reserved.
-- 
1.8.4.4

