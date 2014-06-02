Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaFBQDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:03:14 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:47703 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbaFBQDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:03:13 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkAOAMmfjFNbtAfK/2dsb2JhbABYgwerXwUBmBuBFRd0gwIjgRo3iEYB0TsXhVWIGWQdhCoEj0WKO4sbiBKDOjuBMA
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] lib/asn1_decoder.c: kernel-doc warning fix
Date: Mon,  2 Jun 2014 18:01:55 +0200
Message-Id: <1401724915-2675-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 lib/asn1_decoder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/asn1_decoder.c b/lib/asn1_decoder.c
index 11b9b01..1a000bb 100644
--- a/lib/asn1_decoder.c
+++ b/lib/asn1_decoder.c
@@ -140,7 +140,7 @@ error:
  * @decoder: The decoder definition (produced by asn1_compiler)
  * @context: The caller's context (to be passed to the action functions)
  * @data: The encoded data
- * @datasize: The size of the encoded data
+ * @datalen: The size of the encoded data
  *
  * Decode BER/DER/CER encoded ASN.1 data according to a bytecode pattern
  * produced by asn1_compiler.  Action functions are called on marked tags to
-- 
1.8.4.5

