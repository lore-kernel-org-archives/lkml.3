Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaFYKKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:10:37 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:61425 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752563AbaFYKKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:10:36 -0400
Message-ID: <1403691033.1960.41.camel@x220>
Subject: [PATCH] Documentation: CONFIG_DECNET_ROUTE_FWMARK is obsolete
From: Paul Bolle <pebolle@tiscali.nl>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-decnet-user@lists.sourceforge.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 12:10:33 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2014 10:10:34.0097 (UTC) FILETIME=[B3DC9610:01CF905D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_DECNET_ROUTE_FWMARK is obsolete since v2.6.20.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 Documentation/networking/decnet.txt | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/networking/decnet.txt b/Documentation/networking/decnet.txt
index e12a4900cf72..d192f8b9948b 100644
--- a/Documentation/networking/decnet.txt
+++ b/Documentation/networking/decnet.txt
@@ -22,8 +22,6 @@ you'll need the following options as well...
     CONFIG_DECNET_ROUTER (to be able to add/delete routes)
     CONFIG_NETFILTER (will be required for the DECnet routing daemon)
 
-    CONFIG_DECNET_ROUTE_FWMARK is optional
-
 Don't turn on SIOCGIFCONF support for DECnet unless you are really sure
 that you need it, in general you won't and it can cause ifconfig to
 malfunction.
-- 
1.9.3

