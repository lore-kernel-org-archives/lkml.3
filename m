Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbaLJNyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:54:49 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:55025 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046AbaLJNyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:54:35 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH trivial 3/3] netfilter: ebtables: s/stongly inspired on/strongly inspired by/
Date: Wed, 10 Dec 2014 14:54:30 +0100
Message-Id: <1418219670-18283-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418219670-18283-1-git-send-email-geert+renesas@glider.be>
References: <1418219670-18283-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: David S. Miller <davem@davemloft.net>
---
 include/linux/netfilter_bridge/ebtables.h      | 2 +-
 include/uapi/linux/netfilter_bridge/ebtables.h | 2 +-
 net/bridge/netfilter/ebtables.c                | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 34e7a2b7f8677f9f..9ac6f263956b4ea2 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -6,7 +6,7 @@
  *
  *  ebtables.c,v 2.0, April, 2002
  *
- *  This code is stongly inspired on the iptables code which is
+ *  This code is strongly inspired by the iptables code which is
  *  Copyright (C) 1999 Paul `Rusty' Russell & Michael J. Neuling
  */
 #ifndef __LINUX_BRIDGE_EFF_H
diff --git a/include/uapi/linux/netfilter_bridge/ebtables.h b/include/uapi/linux/netfilter_bridge/ebtables.h
index ba993360dbe908cf..ab46c805c455741f 100644
--- a/include/uapi/linux/netfilter_bridge/ebtables.h
+++ b/include/uapi/linux/netfilter_bridge/ebtables.h
@@ -6,7 +6,7 @@
  *
  *  ebtables.c,v 2.0, April, 2002
  *
- *  This code is stongly inspired on the iptables code which is
+ *  This code is strongly inspired by the iptables code which is
  *  Copyright (C) 1999 Paul `Rusty' Russell & Michael J. Neuling
  */
 
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index d9a8c05d995d1446..54df89edcf204e25 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -6,7 +6,7 @@
  *
  *  ebtables.c,v 2.0, July, 2002
  *
- *  This code is stongly inspired on the iptables code which is
+ *  This code is strongly inspired by the iptables code which is
  *  Copyright (C) 1999 Paul `Rusty' Russell & Michael J. Neuling
  *
  *  This program is free software; you can redistribute it and/or
-- 
1.9.1

