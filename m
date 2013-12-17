Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab3LQGMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 01:12:15 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:64901 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab3LQGLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 01:11:40 -0500
X-AuditID: 9c93017e-b7c17ae000003961-39-52afeb18f26c
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 4/5] zram: add zram maintainers
Date: Tue, 17 Dec 2013 15:12:02 +0900
Message-Id: <1387260723-15817-5-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387260723-15817-1-git-send-email-minchan@kernel.org>
References: <1387260723-15817-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds maintainer information for zram into the MAINTAINERS
file.

Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d077c89b0440..7b32aa4b5f04 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9692,6 +9692,14 @@ T:	Mercurial http://linuxtv.org/hg/v4l-dvb
 S:	Odd Fixes
 F:	drivers/media/pci/zoran/
 
+ZRAM COMPRESSED RAM BLOCK DEVICE DRVIER
+M:	Minchan Kim <minchan@kernel.org>
+M:	Nitin Gupta <ngupta@vflare.org>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	drivers/block/zram/
+F:	Documentation/blockdev/zram.txt
+
 ZS DECSTATION Z85C30 SERIAL DRIVER
 M:	"Maciej W. Rozycki" <macro@linux-mips.org>
 S:	Maintained
-- 
1.7.9.5

