Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbaLFSHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 13:07:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55583 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaLFSHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 13:07:31 -0500
Date: Sat, 6 Dec 2014 19:07:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
        Trivial patch monkey <trivial@kernel.org>
Subject: Make it clear that cache-l2x0 handles L310 cache controller, too
Message-ID: <20141206180728.GA28893@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It is not clear from the filename, and comment at the begining adds to
the confusion by not listing L310. Fix it.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 5e65ca8..b07cc54 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -1,5 +1,5 @@
 /*
- * arch/arm/mm/cache-l2x0.c - L210/L220 cache controller support
+ * arch/arm/mm/cache-l2x0.c - L210/L220/L310 cache controller support
  *
  * Copyright (C) 2007 ARM Limited
  *

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
