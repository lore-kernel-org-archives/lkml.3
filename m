Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbaHZLti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:49:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36349 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbaHZLth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:49:37 -0400
Date: Tue, 26 Aug 2014 13:49:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        Andrew Morton <akpm@osdl.org>
Subject: [PATCH] init/do_mounts: better syntax description
Message-ID: <20140826114935.GA16731@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specify hex device number unambiquously.
    
Signed-off-by: Pavel Machek <pavel@denx.de>

diff --git a/init/do_mounts.c b/init/do_mounts.c
index b6237c3..9f9d5e5 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -182,7 +182,8 @@ done:
 /*
  *	Convert a name into device number.  We accept the following variants:
  *
- *	1) device number in hexadecimal	represents itself
+ *	1) <hex_major><hex_minor> device number in hexadecimal represents itself
+ *         no leading 0x, for example b302.
  *	2) /dev/nfs represents Root_NFS (0xff)
  *	3) /dev/<disk_name> represents the device number of disk
  *	4) /dev/<disk_name><decimal> represents the device number

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
