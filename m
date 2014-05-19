Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbaESTbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:31:51 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:16004 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754973AbaESTbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:31:50 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArYVAPZbelNbtAXp/2dsb2JhbABZgwaCRKgzBAEBAQEBAQUBmicCAoEZF3SCZhwjGIECJBOIRQHSX4VViBdkhEcBA48viioBkxqDOTuBMQ
Date: Mon, 19 May 2014 21:31:45 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 1/1] fs/jffs2/compr.c: remove 0 assignment on static
Message-Id: <20140519213145.e75dbd1aa74fc2ccd9193686@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

static values are automatically initialized to NULL

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/jffs2/compr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jffs2/compr.c b/fs/jffs2/compr.c
index 4849a4c..a673221 100644
--- a/fs/jffs2/compr.c
+++ b/fs/jffs2/compr.c
@@ -25,7 +25,8 @@ static LIST_HEAD(jffs2_compressor_list);
 static int jffs2_compression_mode = JFFS2_COMPR_MODE_PRIORITY;
 
 /* Statistics for blocks stored without compression */
-static uint32_t none_stat_compr_blocks=0,none_stat_decompr_blocks=0,none_stat_compr_size=0;
+static uint32_t none_stat_compr_blocks, none_stat_decompr_blocks,
+		none_stat_compr_size;
 
 
 /*
-- 
1.8.4.5

