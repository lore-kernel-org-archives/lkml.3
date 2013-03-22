Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423100Ab3CVVpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 17:45:54 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:65523 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422984Ab3CVVpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 17:45:53 -0400
Message-ID: <1363988751.1390.199.camel@x61.thuisdomein>
Subject: [PATCH] CRIS: remove "config OOM_REBOOT"
From: Paul Bolle <pebolle@tiscali.nl>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org
Date: Fri, 22 Mar 2013 22:45:51 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Mar 2013 21:45:52.0791 (UTC) FILETIME=[A01F1A70:01CE2746]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol OOM_REBOOT got added in v2.6.25. It has never been
used. Its entry can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/cris/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index b02ca1b..64c590f 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -99,9 +99,6 @@ config ETRAX_KMALLOCED_MODULES
 	help
 	  Enable module allocation with kmalloc instead of vmalloc.
 
-config OOM_REBOOT
-       bool "Enable reboot at out of memory"
-
 source "kernel/Kconfig.preempt"
 
 source mm/Kconfig
-- 
1.7.11.7

