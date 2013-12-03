Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab3LCC3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:29:31 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53787 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab3LCC3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:29:25 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        William Hubbs <w.d.hubbs@gmail.com>,
        Chris Brannon <chris@the-brannons.com>, Kirk Reiser <kirk@reisers.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v2 05/23] mm/staging: remove unnecessary inclusion of bootmem.h
Date: Mon, 2 Dec 2013 21:27:20 -0500
Message-ID: <1386037658-3161-6-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com>
References: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

Clean-up to remove depedency with bootmem headers.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: William Hubbs <w.d.hubbs@gmail.com>
Cc: Chris Brannon <chris@the-brannons.com>
Cc: Kirk Reiser <kirk@reisers.ca>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/staging/speakup/main.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/speakup/main.c b/drivers/staging/speakup/main.c
index 47502fa..ef5933b 100644
--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -37,8 +37,6 @@
 #include <linux/input.h>
 #include <linux/kmod.h>
 
-#include <linux/bootmem.h>	/* for alloc_bootmem */
-
 /* speakup_*_selection */
 #include <linux/module.h>
 #include <linux/sched.h>
-- 
1.7.9.5

