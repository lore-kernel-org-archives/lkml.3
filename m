Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab3J2SBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:01:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:3467 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab3J2SBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:01:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="426608246"
From: David Cohen <david.a.cohen@linux.intel.com>
To: broonie@kernel.org
Cc: ning.li@intel.com, linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH 2/2] MAINTAINERS: add Intel MID SSP SPI maintainers
Date: Tue, 29 Oct 2013 11:05:50 -0700
Message-Id: <1383069950-27754-2-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2f60504..8574aa2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1916,6 +1916,14 @@ L:	linux-gpio@vger.kernel.org
 S:	Maintained
 F:	drivers/gpio/gpio-intel-mid.c
 
+INTEL-MID SSP SPI DRIVER
+M:	Ning Li <ning.li@intel.com>
+M:	David Cohen <david.a.cohen@linux.intel.com>
+L:	linux-spi@vger.kernel.org
+S:	Maintained
+F:	drivers/spi/spi-intel-mid-ssp.c
+F:	include/linux/spi/intel_mid_ssp_spi.h
+
 BTRFS FILE SYSTEM
 M:	Chris Mason <chris.mason@fusionio.com>
 L:	linux-btrfs@vger.kernel.org
-- 
1.8.4.rc3

