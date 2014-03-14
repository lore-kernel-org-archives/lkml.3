Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbaCNPWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:22:11 -0400
Received: from 124-84-246-161.wendulka.net ([84.246.161.124]:53752 "EHLO
	ixit.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754959AbaCNPWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:22:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Mar 2014 17:15:01 +0100
From: David Heidelberger <david.heidelberger@ixit.cz>
To: linux-kernel@vger.kernel.org
Cc: maillist-linux@barfooze.de
Subject: [PATCH 2/4] =?UTF-8?Q?if=5Fbridge=2Eh=3A=20needs=20struct=20in=36?=
 =?UTF-8?Q?=5Faddr?=
Message-ID: <bfe184b0f2e4be53f013b24652b3e48f@ixit.cz>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: John Spencer <maillist-linux@barfooze.de>
Tested-by: David Heidelberger <david.heidelberger@ixit.cz>
---
  include/uapi/linux/if_bridge.h | 1 +
  1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/if_bridge.h 
b/include/uapi/linux/if_bridge.h
index 39f621a..da17e45 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -15,6 +15,7 @@

  #include <linux/types.h>
  #include <linux/if_ether.h>
+#include <linux/in6.h>

  #define SYSFS_BRIDGE_ATTR	"bridge"
  #define SYSFS_BRIDGE_FDB	"brforward"
-- 
1.8.4

