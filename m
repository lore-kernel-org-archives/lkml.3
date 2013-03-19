Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964969Ab3CSJ0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:26:37 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:60226 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884Ab3CSJ0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:26:31 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v4 8/8] staging: zcache: clean TODO list
Date: Tue, 19 Mar 2013 17:25:50 +0800
Message-Id: <1363685150-18303-9-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363685150-18303-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1363685150-18303-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031909-4790-0000-0000-00000773F026
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup TODO list since support zero-filled pages more efficiently has 
already done by this patchset.

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 drivers/staging/zcache/TODO |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zcache/TODO b/drivers/staging/zcache/TODO
index ec9aa11..d0c18fa 100644
--- a/drivers/staging/zcache/TODO
+++ b/drivers/staging/zcache/TODO
@@ -61,5 +61,4 @@ ZCACHE FUTURE NEW FUNCTIONALITY
 
 A. Support zsmalloc as an alternative high-density allocator
     (See https://lkml.org/lkml/2013/1/23/511)
-B. Support zero-filled pages more efficiently
-C. Possibly support three zbuds per pageframe when space allows
+B. Possibly support three zbuds per pageframe when space allows
-- 
1.7.7.6

