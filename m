Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaBLKym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:54:42 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:60814 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbaBLKyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:54:39 -0500
Message-ID: <1392202477.23759.28.camel@x220>
Subject: [PATCH] blackfin: Remove GENERIC_GPIO config option again
From: Paul Bolle <pebolle@tiscali.nl>
To: Steven Miao <realmz6@gmail.com>
Cc: adi-buildroot-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Wed, 12 Feb 2014 11:54:37 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2014 10:54:37.0332 (UTC) FILETIME=[D2697D40:01CF27E0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol GENERIC_GPIO was removed in v3.10. Nothing cares
about it anymore. It popped up somehow in v3.13, so it can be removed
again.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested, but safe anyhow.

 arch/blackfin/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 9ceccef..debd9df 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -51,9 +51,6 @@ config GENERIC_BUG
 config ZONE_DMA
 	def_bool y
 
-config GENERIC_GPIO
-	def_bool y
-
 config FORCE_MAX_ZONEORDER
 	int
 	default "14"
-- 
1.8.5.3

