Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbaFKKDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 06:03:52 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:60994 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133AbaFKKDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 06:03:51 -0400
Message-ID: <1402481029.3798.68.camel@x220>
Subject: [PATCH] [TRIVIAL] SH: add proper prompt to SH_MAGIC_PANEL_R2_VERSION
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 11 Jun 2014 12:03:49 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2014 10:03:49.0680 (UTC) FILETIME=[7106F300:01CF855C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with make ARCH=sh menuconfig

The new prompt isn't very informative. But at least it's better than the
current, well, self referential prompt. SuperH is orphaned, so chances
are we'll never see anything better.

By the way: why do the kconfig tools allow unquoted prompts?

 arch/sh/boards/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/boards/Kconfig b/arch/sh/boards/Kconfig
index e331e5373b8e..89963d13f930 100644
--- a/arch/sh/boards/Kconfig
+++ b/arch/sh/boards/Kconfig
@@ -371,7 +371,7 @@ if SH_MAGIC_PANEL_R2
 menu "Magic Panel R2 options"
 
 config SH_MAGIC_PANEL_R2_VERSION
-	int SH_MAGIC_PANEL_R2_VERSION
+	int "Magic Panel R2 Version"
 	default "3"
 	help
 	  Set the version of the Magic Panel R2
-- 
1.9.3

