Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab3CGKgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:36:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:11109 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932541Ab3CGKgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:36:03 -0500
X-IronPort-AV: E=Sophos;i="4.84,801,1355068800"; 
   d="scan'208";a="6831343"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: lenb@kernel.org, rjw@sisk.pl, robert.moore@intel.com, lv.zheng@intel.com,
        ming.m.lin@intel.com, mpm@selenic.com, herbert@gondor.hengli.com.au,
        rob@landley.net
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, trivial@kernel.org
Subject: [RESEND PATCH 6/6] doc: Fix a wrong comment in Documentation/hw_random.txt
Date: Thu, 7 Mar 2013 18:38:17 +0800
Message-Id: <1362652697-30284-7-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1362652697-30284-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1362652697-30284-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/07 18:34:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/07 18:34:53,
	Serialize complete at 2013/03/07 18:34:53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seeing from the comment, there should be three reasons for removing request_mem_region.
Change the comment "two" to "three".

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Acked-by: Rob Landley <rob@landley.net> 
---
 Documentation/hw_random.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/hw_random.txt b/Documentation/hw_random.txt
index 690f525..026e237 100644
--- a/Documentation/hw_random.txt
+++ b/Documentation/hw_random.txt
@@ -63,7 +63,7 @@ Intel RNG Driver notes:
 
 	* FIXME: support poll(2)
 
-	NOTE: request_mem_region was removed, for two reasons:
+	NOTE: request_mem_region was removed, for three reasons:
 	1) Only one RNG is supported by this driver, 2) The location
 	used by the RNG is a fixed location in MMIO-addressable memory,
 	3) users with properly working BIOS e820 handling will always
-- 
1.7.1

