Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab3COL7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 07:59:37 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:64254 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753921Ab3COL7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 07:59:36 -0400
Message-ID: <1363348770.1335.102.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] Fix typo "----help---"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 15 Mar 2013 12:59:30 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Mar 2013 11:59:30.0945 (UTC) FILETIME=[8D372F10:01CE2174]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) The kconfig parsing code doesn't care about this typo. Not sure why,
actually. Staring at zconf.l reveals "---" will be ignored, anywhere.
But it's a mystery why one or two minuses will sometimes also be
ignored. The joys of lex and yacc! Anyhow, it's a typo.

1) In case you fear a steady stream of trivialities like this: I've
actually grepped the tree for all typos of this kind and there seem to
be none left.

 drivers/net/ethernet/sfc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
index 435b4f1..4136ccc 100644
--- a/drivers/net/ethernet/sfc/Kconfig
+++ b/drivers/net/ethernet/sfc/Kconfig
@@ -24,7 +24,7 @@ config SFC_MCDI_MON
 	bool "Solarflare SFC9000-family hwmon support"
 	depends on SFC && HWMON && !(SFC=y && HWMON=m)
 	default y
-	----help---
+	---help---
 	  This exposes the on-board firmware-managed sensors as a
 	  hardware monitor device.
 config SFC_SRIOV
-- 
1.7.11.7

