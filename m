Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbbATMbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:31:34 -0500
Received: from mx02.posteo.de ([89.146.194.165]:55438 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbbATMbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:31:32 -0500
From: Martin Kepplinger <martink@posteo.de>
To: torvalds@linux-foundation.org, jsrhbz@kanargh.force9.co.uk,
        christoph.muellner@theobroma-systems.com, linux@roeck-us.net,
        linux@rasmusvillemoes.dk, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, mingo@kernel.org, akpm@linux-foundation.org,
        hpa@zytor.com, maxime.coquelin@st.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tytso@mit.edu
Cc: linux-tip-commits@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH 1/2] bitops.h: improve documentation for sign_extend32()
Date: Tue, 20 Jan 2015 13:30:54 +0100
Message-Id: <1421757055-8234-2-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421757055-8234-1-git-send-email-martink@posteo.de>
References: <CA+55aFycO_d0oO9rw9fXa13NSNc0Am8v+3rV+eSH9YdsCi-2Mg@mail.gmail.com>
 <1421757055-8234-1-git-send-email-martink@posteo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
 include/linux/bitops.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 5d858e0..336f22b 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -164,6 +164,8 @@ static inline __u8 ror8(__u8 word, unsigned int shift)
  * sign_extend32 - sign extend a 32-bit value using specified bit as sign-bit
  * @value: value to sign extend
  * @index: 0 based bit index (0<=index<32) to sign bit
+ *
+ * Safe to use for sign extending to 8 and 16 bit data types aswell.
  */
 static inline __s32 sign_extend32(__u32 value, int index)
 {
-- 
2.1.4

