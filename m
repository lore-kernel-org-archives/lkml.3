Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936812Ab3DHKv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:51:29 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:57603 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761729Ab3DHKv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:51:27 -0400
Message-ID: <1365418285.1830.90.camel@x61.thuisdomein>
Subject: [PATCH v2] doc: change example to existing Makefile fragment
From: Paul Bolle <pebolle@tiscali.nl>
To: Michal Marek <mmarek@suse.cz>
Cc: Rob Landley <rob@landley.net>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 12:51:25 +0200
In-Reply-To: <51629F0F.6070501@suse.cz>
References: <1364206584.1390.268.camel@x61.thuisdomein>
	 <1364258406.15703.70@driftwood> <51629F0F.6070501@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2013 10:51:25.0403 (UTC) FILETIME=[03F4F2B0:01CE3447]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Acked-by: Rob Landley <rob@landley.net>
---
v2: added Rob's ACK and send to Michal e.a., for the kbuild tree.

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

