Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaCXVvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 17:51:55 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:37934 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbaCXVvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 17:51:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkwMAFioMFNbsHVW/2dsb2JhbABZgwaCSYERwCMEAoEjF3SCZhwjGIECJBOHfQHPRY56hD8EmEkBilmHWIMuPA
Date: Mon, 24 Mar 2014 22:51:51 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Tytso <tytso@mit.edu>
Subject: [PATCH 1/1] fs/ext4/ioctl.c: Remove unused macro MAX_32_NUM
Message-Id: <20140324225151.d39b2363e9f45cf544cfbd66@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

01f795f9e0d67a
("ext4: add online resizing support for meta_bg and 64-bit file systems")
removed the last use of MAX_32_NUM

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/ioctl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a2a837f..ea5dace 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -18,8 +18,6 @@
 #include "ext4_jbd2.h"
 #include "ext4.h"
 
-#define MAX_32_NUM ((((unsigned long long) 1) << 32) - 1)
-
 /**
  * Swap memory between @a and @b for @len bytes.
  *
