Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab3CULCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:02:03 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:60013 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754345Ab3CULCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:02:02 -0400
Message-ID: <1363863720.1390.109.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] removed outdated 'noresidual' parameter
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 12:02:00 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Mar 2013 11:02:00.0428 (UTC) FILETIME=[830692C0:01CE2623]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PPC specific kernel parameter 'noresidual' was removed in v2.6.27,
though commit 917f0af9e5a9ceecf9e72537fabb501254ba321d ("powerpc: Remove
arch/ppc and include/asm-ppc").

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 Documentation/kernel-parameters.txt | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..751d965 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1974,8 +1974,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	noreplace-smp	[X86-32,SMP] Don't replace SMP instructions
 			with UP alternatives
 
-	noresidual	[PPC] Don't use residual data on PReP machines.
-
 	nordrand	[X86] Disable the direct use of the RDRAND
 			instruction even if it is supported by the
 			processor.  RDRAND is still available to user
-- 
1.7.11.7

