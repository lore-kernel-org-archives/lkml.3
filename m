Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab3CIVTi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 16:19:38 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:62439 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079Ab3CIVTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 16:19:37 -0500
Message-ID: <1362863975.3137.39.camel@x61.thuisdomein>
Subject: [PATCH] zcache: fix typo "64_BIT"
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sat, 09 Mar 2013 22:19:35 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2013 21:19:34.0860 (UTC) FILETIME=[CC3B30C0:01CE1D0B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested! This specifically needs testing on (some) 64 bit platforms,
because this means HAVE_ALIGNED_STRUCT_PAGE will not be selected anymore
on those platforms.

 drivers/staging/zcache/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
index 7358270..5c37145 100644
--- a/drivers/staging/zcache/Kconfig
+++ b/drivers/staging/zcache/Kconfig
@@ -15,7 +15,7 @@ config RAMSTER
 	depends on CONFIGFS_FS=y && SYSFS=y && !HIGHMEM && ZCACHE=y
 	depends on NET
 	# must ensure struct page is 8-byte aligned
-	select HAVE_ALIGNED_STRUCT_PAGE if !64_BIT
+	select HAVE_ALIGNED_STRUCT_PAGE if !64BIT
 	default n
 	help
 	  RAMster allows RAM on other machines in a cluster to be utilized
-- 
1.7.11.7

