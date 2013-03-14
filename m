Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3CNKJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:09:12 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:58475 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635Ab3CNKJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:09:10 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 4/4] clean TODO list
Date: Thu, 14 Mar 2013 18:08:17 +0800
Message-Id: <1363255697-19674-5-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363255697-19674-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1363255697-19674-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031410-1618-0000-0000-000003814C8E
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
index c1e26d4..9e755d3 100644
--- a/drivers/staging/zcache/TODO
+++ b/drivers/staging/zcache/TODO
@@ -65,5 +65,4 @@ ZCACHE FUTURE NEW FUNCTIONALITY
 
 A. Support zsmalloc as an alternative high-density allocator
     (See https://lkml.org/lkml/2013/1/23/511)
-B. Support zero-filled pages more efficiently
-C. Possibly support three zbuds per pageframe when space allows
+B. Possibly support three zbuds per pageframe when space allows
-- 
1.7.7.6

