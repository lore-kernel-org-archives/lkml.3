Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762383Ab3IDK64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 06:58:56 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:51300 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab3IDK6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 06:58:54 -0400
Message-ID: <52271255.2080604@huawei.com>
Date: Wed, 4 Sep 2013 18:58:29 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <rob@landley.net>, <trivial@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH] doc: Documentation/cputopology.txt fix typo
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a trivial typo in Documentation/cputopology.txt

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 Documentation/cputopology.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/cputopology.txt b/Documentation/cputopology.txt
index 902d315..0aad6de 100644
--- a/Documentation/cputopology.txt
+++ b/Documentation/cputopology.txt
@@ -22,7 +22,7 @@ to /proc/cpuinfo.
 
 4) /sys/devices/system/cpu/cpuX/topology/thread_siblings:
 
-	internel kernel map of cpuX's hardware threads within the same
+	internal kernel map of cpuX's hardware threads within the same
 	core as cpuX
 
 5) /sys/devices/system/cpu/cpuX/topology/core_siblings:
-- 
1.7.1


