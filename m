Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbaFYHUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:20:54 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:63951 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbaFYHUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:20:53 -0400
Message-ID: <1403680851.1960.28.camel@x220>
Subject: [PATCH] Documentation: memcg: use 'CONFIG_MEMCG_SWAP'
From: Paul Bolle <pebolle@tiscali.nl>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 09:20:51 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2014 07:20:52.0170 (UTC) FILETIME=[FEF5D2A0:01CF9045]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c255a458055e ("memcg: rename config variables") renamed
CONFIG_CGROUP_MEM_RES_CTLR_SWAP to CONFIG_MEMCG_SWAP. It missed this use
of that macro due to two typos. Rename it too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
The second typo is bit subtle!

 Documentation/cgroups/memcg_test.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/cgroups/memcg_test.txt b/Documentation/cgroups/memcg_test.txt
index 8870b0212150..3759237f8b2c 100644
--- a/Documentation/cgroups/memcg_test.txt
+++ b/Documentation/cgroups/memcg_test.txt
@@ -48,7 +48,7 @@ Please note that implementation details can be changed.
 
 	At cancel(), simply usage -= PAGE_SIZE.
 
-Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
+Under below explanation, we assume CONFIG_MEMCG_SWAP=y.
 
 4. Anonymous
 	Anonymous page is newly allocated at
-- 
1.9.3

