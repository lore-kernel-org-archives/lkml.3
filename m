Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab3KLRrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:47:14 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:43110
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755449Ab3KLRrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:47:06 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h1155h)
X-WSS-ID: 0MW5W0J-07-EDG-02
X-M-MSG: 
Subject: [PATCH 10/10] crypto: CCP maintainer information
To: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <herbert@gondor.hengli.com.au>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Tue, 12 Nov 2013 11:46:57 -0600
Message-ID: <20131112174657.19746.44224.stgit@tlendack-t1.amdoffice.net>
In-Reply-To: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
References: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the MAINTAINERS file for the AMD CCP device driver.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 051e4dc..de22604 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -525,6 +525,13 @@ F:	drivers/tty/serial/altera_jtaguart.c
 F:	include/linux/altera_uart.h
 F:	include/linux/altera_jtaguart.h
 
+AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER
+M:	Tom Lendacky <thomas.lendacky@amd.com>
+L:	linux-crypto@vger.kernel.org
+S:	Supported
+F:	drivers/crypto/ccp/
+F:	include/linux/ccp.h
+
 AMD FAM15H PROCESSOR POWER MONITORING DRIVER
 M:	Andreas Herrmann <herrmann.der.user@googlemail.com>
 L:	lm-sensors@lm-sensors.org


