Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaEZTCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:02:40 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:63492 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751200AbaEZTCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:02:39 -0400
Message-ID: <1401130958.6068.17.camel@x220>
Subject: [PATCH] [TRIVIAL] staging: go7007: remove reference to CONFIG_KMOD
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 26 May 2014 21:02:38 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2014 19:02:38.0240 (UTC) FILETIME=[0FBDBA00:01CF7915]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol KMOD was removed in v2.6.29. Remove CONFIG_KMOD from
this list of options too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/staging/media/go7007/go7007.txt | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/go7007/go7007.txt b/drivers/staging/media/go7007/go7007.txt
index dc0026cff9f6..c8e5eb09d385 100644
--- a/drivers/staging/media/go7007/go7007.txt
+++ b/drivers/staging/media/go7007/go7007.txt
@@ -79,7 +79,6 @@ for custom-built kernels, the following options need to be enabled in the
 kernel as built-in or modules:
 
 	CONFIG_MODULES           - Enable loadable module support
-	CONFIG_KMOD              - Automatic kernel module loading
 	CONFIG_FW_LOADER         - Hotplug firmware loading support
 	CONFIG_I2C               - I2C support
 	CONFIG_VIDEO_DEV         - Video For Linux
-- 
1.9.0

