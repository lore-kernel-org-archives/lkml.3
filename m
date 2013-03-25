Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3CYKQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:16:30 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:55962 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754923Ab3CYKQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:16:27 -0400
Message-ID: <1364206584.1390.268.camel@x61.thuisdomein>
Subject: [PATCH] doc: change example to existing Makefile fragment
From: Paul Bolle <pebolle@tiscali.nl>
To: Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 11:16:24 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2013 10:16:25.0341 (UTC) FILETIME=[CE706AD0:01CE2941]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 Documentation/kbuild/makefiles.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 5198b74..020bb67 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -921,8 +921,9 @@ When kbuild executes, the following steps are followed (roughly):
 	Often, the KBUILD_CFLAGS variable depends on the configuration.
 
 	Example:
-		#arch/x86/Makefile
-		cflags-$(CONFIG_M386) += -march=i386
+		#arch/x86/boot/compressed/Makefile
+		cflags-$(CONFIG_X86_32) := -march=i386
+		cflags-$(CONFIG_X86_64) := -mcmodel=small
 		KBUILD_CFLAGS += $(cflags-y)
 
 	Many arch Makefiles dynamically run the target C compiler to
-- 
1.7.11.7



