Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbaCLRXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:23:50 -0400
Received: from smtprelay0188.hostedemail.com ([216.40.44.188]:58299 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755569AbaCLRXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:23:23 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3350:3865:3866:3867:3868:5007:6261:10004:10026:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:12690:12737:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jelly44_9171a2500901c
X-Filterd-Recvd-Size: 1776
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 9/9] ath9k: Convert uses of __constant_<foo> to <foo>
Date: Wed, 12 Mar 2014 10:22:38 -0700
Message-Id: <b44fc68ea21f435c665dee1b2d1d89d6e53bd703.1394644825.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1394644825.git.joe@perches.com>
References: <cover.1394644825.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of __constant_<foo> has been unnecessary for quite awhile now.

Make these uses consistent with the rest of the kernel.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index b8daff7..d7625ec 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -23,8 +23,8 @@
 #define COMP_HDR_LEN 4
 #define COMP_CKSUM_LEN 2
 
-#define LE16(x) __constant_cpu_to_le16(x)
-#define LE32(x) __constant_cpu_to_le32(x)
+#define LE16(x) cpu_to_le16(x)
+#define LE32(x) cpu_to_le32(x)
 
 /* Local defines to distinguish between extension and control CTL's */
 #define EXT_ADDITIVE (0x8000)
-- 
1.8.1.2.459.gbcd45b4.dirty

