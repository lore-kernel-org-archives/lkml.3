Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab3ELVV2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 17:21:28 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:60363 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631Ab3ELVV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 17:21:27 -0400
Message-ID: <1368393684.1350.16.camel@x61.thuisdomein>
Subject: [PATCH] NFC: remove commented out Makefile line
From: Paul Bolle <pebolle@tiscali.nl>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, linux-nfc@ml01.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 12 May 2013 23:21:24 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 May 2013 21:21:24.0981 (UTC) FILETIME=[A84E5250:01CE4F56]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol NFC_LLCP was removed in commit 30cc458765 ("NFC: Move
LLCP code to the NFC top level diirectory"). But the reference to its
macro in this Makefile was only commented out. Remove it now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 net/nfc/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/nfc/Makefile b/net/nfc/Makefile
index fb799de..a76f453 100644
--- a/net/nfc/Makefile
+++ b/net/nfc/Makefile
@@ -5,7 +5,6 @@
 obj-$(CONFIG_NFC) += nfc.o
 obj-$(CONFIG_NFC_NCI) += nci/
 obj-$(CONFIG_NFC_HCI) += hci/
-#obj-$(CONFIG_NFC_LLCP) += llcp/
 
 nfc-objs := core.o netlink.o af_nfc.o rawsock.o llcp_core.o llcp_commands.o \
 		llcp_sock.o
-- 
1.7.11.7

