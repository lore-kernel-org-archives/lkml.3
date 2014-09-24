Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbaIXIGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:06:31 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:62465 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772AbaIXIGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:06:22 -0400
Message-ID: <1411545979.19525.5.camel@x220>
Subject: [PATCH] powerpc/8xx: Remove Kconfig symbol FADS
From: Paul Bolle <pebolle@tiscali.nl>
To: Vitaly Bordug <vitb@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Wed, 24 Sep 2014 10:06:19 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Sep 2014 08:06:19.0805 (UTC) FILETIME=[6C5924D0:01CFD7CE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 39eb56da2b53 ("pcmcia: Remove m8xx_pcmcia driver") removed the
only driver that used CONFIG_FADS. Setting the Kconfig symbol FADS is
pointless since that commit. Remove it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Done on top of next-20140923. Tested with "git grep" only.

Another cleanup might be to remove MPC8XXFADS (or "FADS") from the "8xx
Machine Type" choice. Is there any reason left to pick "FADS" as a
machine type?

 arch/powerpc/platforms/8xx/Kconfig | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/powerpc/platforms/8xx/Kconfig b/arch/powerpc/platforms/8xx/Kconfig
index 247fdea0c8be..831f2e718b06 100644
--- a/arch/powerpc/platforms/8xx/Kconfig
+++ b/arch/powerpc/platforms/8xx/Kconfig
@@ -1,6 +1,3 @@
-config FADS
-	bool
-
 config CPM1
 	bool
 	select CPM
@@ -13,7 +10,6 @@ choice
 
 config MPC8XXFADS
 	bool "FADS"
-	select FADS
 
 config MPC86XADS
 	bool "MPC86XADS"
-- 
1.9.3

