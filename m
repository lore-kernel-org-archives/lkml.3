Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbaFXMMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:12:40 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:55739 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753169AbaFXMMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:12:39 -0400
Message-ID: <1403611956.1960.17.camel@x220>
Subject: [PATCH] Documentation/Changes: cleanup mcelog paragraph
From: Paul Bolle <pebolle@tiscali.nl>
To: Andi Kleen <ak@linux.intel.com>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 24 Jun 2014 14:12:36 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2014 12:12:37.0078 (UTC) FILETIME=[96490F60:01CF8FA5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The paragraph on mcelog currently describes kernel v2.6.31. In that
kernel the mce code (for i386, that is) was in transition. Ever since
v2.6.32 the situation is much simpler (eg, mcelog is now needed to
process events on almost all x86 machines, i386 and x86-64). Since this
"document is designed to provide a list of the minimum levels of
software necessary to run the 3.0 kernels" let's just describe that
situation.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 Documentation/Changes | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/Documentation/Changes b/Documentation/Changes
index 2254db0f00a5..227bec88021e 100644
--- a/Documentation/Changes
+++ b/Documentation/Changes
@@ -280,12 +280,9 @@ that is possible.
 mcelog
 ------
 
-In Linux 2.6.31+ the i386 kernel needs to run the mcelog utility
-as a regular cronjob similar to the x86-64 kernel to process and log
-machine check events when CONFIG_X86_NEW_MCE is enabled. Machine check
-events are errors reported by the CPU. Processing them is strongly encouraged.
-All x86-64 kernels since 2.6.4 require the mcelog utility to
-process machine checks.
+On x86 kernels the mcelog utility is needed to process and log machine check
+events when CONFIG_X86_MCE is enabled. Machine check events are errors reported
+by the CPU. Processing them is strongly encouraged.
 
 Getting updated software
 ========================
-- 
1.9.3

