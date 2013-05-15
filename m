Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab3EOJLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:11:12 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:50969 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753499Ab3EOJLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:11:10 -0400
Message-ID: <1368609068.1350.182.camel@x61.thuisdomein>
Subject: [PATCH] mn10300: remove dependency on MN10300_PROC_MN2WS0038
From: Paul Bolle <pebolle@tiscali.nl>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 15 May 2013 11:11:08 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 May 2013 09:11:09.0058 (UTC) FILETIME=[23384E20:01CE514C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entry for "Symmetric multi-processing support" got added in
v2.6.37. It has an optional dependency on MN10300_PROC_MN2WS0038. But
that Kconfig symbol has never been part of the tree. So this optional
dependency can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested by grepping the tree.

 arch/mn10300/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 428da17..7f9f34c 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -182,7 +182,7 @@ config SMP
 	bool "Symmetric multi-processing support"
 	default y
 	select USE_GENERIC_SMP_HELPERS
-	depends on MN10300_PROC_MN2WS0038 || MN10300_PROC_MN2WS0050
+	depends on MN10300_PROC_MN2WS0050
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
-- 
1.7.11.7

