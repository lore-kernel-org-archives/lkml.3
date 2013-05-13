Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab3EMPBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 11:01:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28215 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab3EMPBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 11:01:15 -0400
Date: Mon, 13 May 2013 18:00:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Cc: "Busch, Keith" <keith.busch@intel.com>,
        "Verma, Vishal L" <vishal.l.verma@intel.com>,
        linux-nvme@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: [patch] MAINTAINERS: update NVM EXPRESS DRIVER file list
Message-ID: <20130513150042.GB21239@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <100D68C7BA14664A8938383216E40DE027F80EAB@fmsmsx111.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There isn't an nvme.c file any more.  It has been split into multiple
files.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 8f190f5..97ec343 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5747,7 +5747,7 @@ M:	Matthew Wilcox <willy@linux.intel.com>
 L:	linux-nvme@lists.infradead.org
 T:	git git://git.infradead.org/users/willy/linux-nvme.git
 S:	Supported
-F:	drivers/block/nvme.c
+F:	drivers/block/nvme*
 F:	include/linux/nvme.h
 
 OMAP SUPPORT
