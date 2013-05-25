Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab3EYD03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 23:26:29 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:61369 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab3EYD02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 23:26:28 -0400
Message-ID: <51A02F59.8000103@gmail.com>
Date: Sat, 25 May 2013 11:26:17 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Simon Horman <horms@verge.net.au>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        davej@redhat.com
Subject: [PATCH 2/7] Documentation/devices.txt: Remove /dev/oldmem description
References: <51A02E50.5020507@gmail.com>
In-Reply-To: <51A02E50.5020507@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Dave Jones <davej@redhat.com>
---
 Documentation/devices.txt |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 08f01e7..4f85739 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -100,8 +100,6 @@ Your cooperation is appreciated.
 		 10 = /dev/aio		Asynchronous I/O notification interface
 		 11 = /dev/kmsg		Writes to this come out as printk's, reads
 					export the buffered printk records.
-		 12 = /dev/oldmem	Used by crashdump kernels to access
-					the memory of the kernel that crashed.
 
   1 block	RAM disk
 		  0 = /dev/ram0		First RAM disk
-- 
1.7.1
