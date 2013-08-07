Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab3HGLDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:03:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51742 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab3HGLDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:03:33 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Subject: [PATCH v3 1/3] mm: make generic_access_phys available for modules
Date: Wed,  7 Aug 2013 13:02:52 +0200
Message-Id: <1375873374-12601-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the next commit this function will be used in the uio subsystem

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

Greg suggested to take this patch together with the next one via his uio
tree with the appropriate acks.

Best regards
Uwe

 mm/memory.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memory.c b/mm/memory.c
index 1ce2e2a..8d9255b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4066,6 +4066,7 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 
 	return len;
 }
+EXPORT_SYMBOL_GPL(generic_access_phys);
 #endif
 
 /*
-- 
1.8.4.rc1

