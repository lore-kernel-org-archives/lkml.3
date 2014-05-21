Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbaEUTvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:51:11 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:9622 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294AbaEUTvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:51:09 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugLAPoCfVNbsHTp/2dsb2JhbABZgwmCRahCBAEBAQEBAQUBgzqWdoEMF3SCZhwjGIECJBOIRQHWT4VViBUWToRHAQOPPYowAZMkgzo7gTEj
Date: Wed, 21 May 2014 21:51:07 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/power/snapshot.c: local symbols made static
Message-Id: <20140521215107.6da8f298175218aa79152f63@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_normal and alloc_highmem are only used in kernel/power/snapshot.c

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/power/snapshot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 1ea328a..0aa960d 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1069,7 +1069,8 @@ static unsigned int nr_meta_pages;
  * Numbers of normal and highmem page frames allocated for hibernation image
  * before suspending devices.
  */
-unsigned int alloc_normal, alloc_highmem;
+static unsigned int alloc_normal;
+static unsigned int alloc_highmem;
 /*
  * Memory bitmap used for marking saveable pages (during hibernation) or
  * hibernation image pages (during restore)
-- 
1.9.1

