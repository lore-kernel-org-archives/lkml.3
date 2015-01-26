Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbbAZMHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:07:06 -0500
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:48411 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753771AbbAZMG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:06:26 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] staging: comedi: 8253.h: reformat other block comments
Date: Mon, 26 Jan 2015 12:06:06 +0000
Message-Id: <1422273967-16407-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422273967-16407-1-git-send-email-abbotti@mev.co.uk>
References: <1422273967-16407-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the usual block comment style.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/8253.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8253.h b/drivers/staging/comedi/drivers/8253.h
index 55f1704..0d9aec0 100644
--- a/drivers/staging/comedi/drivers/8253.h
+++ b/drivers/staging/comedi/drivers/8253.h
@@ -44,9 +44,11 @@ static inline void i8253_cascade_ns_to_timer(int i8253_osc_base,
 	unsigned int start;
 	unsigned int ns_low, ns_high;
 	static const unsigned int max_count = 0x10000;
-	/* exit early if everything is already correct (this can save time
+	/*
+	 * exit early if everything is already correct (this can save time
 	 * since this function may be called repeatedly during command tests
-	 * and execution) */
+	 * and execution)
+	 */
 	div1 = *d1 ? *d1 : max_count;
 	div2 = *d2 ? *d2 : max_count;
 	divider = div1 * div2;
@@ -120,7 +122,8 @@ static inline void i8253_cascade_ns_to_timer(int i8253_osc_base,
 }
 
 #ifndef CMDTEST
-/* i8254_load programs 8254 counter chip.  It should also work for the 8253.
+/*
+ * i8254_load programs 8254 counter chip.  It should also work for the 8253.
  * base_address is the lowest io address
  * for the chip (the address of counter 0).
  * counter_number is the counter you want to load (0,1 or 2)
@@ -274,7 +277,8 @@ static inline void i8254_mm_write(void __iomem *base_address,
 	writeb(byte, base_address + (counter_number << regshift));
 }
 
-/* Set counter mode, should work for 8253 also.
+/*
+ * Set counter mode, should work for 8253 also.
  * Note: the 'mode' value is different to that for i8254_load() and comes
  * from the INSN_CONFIG_8254_SET_MODE command:
  *   I8254_MODE0, I8254_MODE1, ..., I8254_MODE5
-- 
2.1.4

