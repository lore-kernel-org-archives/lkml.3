Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab3CZSCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:02:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15455 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab3CZRgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:04 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ObQ7zcwZue4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=oC92LQqVgmUA:10 a=fh4mg5NFAAAA:8 a=p-L6lgetAAAA:8 a=jZVsG21pAAAA:8 a=J1Y8HTJGAAAA:8 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=M5GUcnROAAAA:8 a=3ngJMz94n3SUPfLH13QA:9 a=RXyFOPM4uSsA:10 a=gJlYqgjm7j4A:10 a=Im-eZXwrtqoA:10 a=v-EnS7xDjQoA:10 a=4N9Db7Z2_RYA:10 a=9RRF0ttvEvMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173601.447659086@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 10/86] MAINTAINERS: Stephen Hemminger email change
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0010-MAINTAINERS-Stephen-Hemminger-email-change.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Stephen Hemminger <stephen.hemminger@vyatta.com>

[ Upstream commit adbbf69d1a54abf424e91875746a610dcc80017d ]

I changed my email because the vyatta.com mail server is now
redirected to brocade.com; and the Brocade mail system
is not friendly to Linux desktop users.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9a6c4da..61ed6f7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2697,7 +2697,7 @@ S:	Maintained
 F:	drivers/net/ethernet/i825xx/eexpress.*
 
 ETHERNET BRIDGE
-M:	Stephen Hemminger <shemminger@vyatta.com>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	bridge@lists.linux-foundation.org
 L:	netdev@vger.kernel.org
 W:	http://www.linuxfoundation.org/en/Net:Bridge
@@ -4420,7 +4420,7 @@ S:	Maintained
 
 MARVELL GIGABIT ETHERNET DRIVERS (skge/sky2)
 M:	Mirko Lindner <mlindner@marvell.com>
-M:	Stephen Hemminger <shemminger@vyatta.com>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/marvell/sk*
@@ -4664,7 +4664,7 @@ S:	Supported
 F:	drivers/infiniband/hw/nes/
 
 NETEM NETWORK EMULATOR
-M:	Stephen Hemminger <shemminger@vyatta.com>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	netem@lists.linux-foundation.org
 S:	Maintained
 F:	net/sched/sch_netem.c
-- 
1.7.10.4


