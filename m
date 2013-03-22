Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab3CVCDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 22:03:14 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:51631 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab3CVCDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 22:03:13 -0400
Message-ID: <514BBBD2.9010602@huawei.com>
Date: Fri, 22 Mar 2013 10:02:58 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH] init/Kconfig: make EXPERT as config instead of menuconfig
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There don't have any EXPERT menu guard, and no config item is
included in EXPERT menu, so change it as a config, not menu.

This will make user more clear when they use 'make menuconfig'
or 'make nconfig'.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>
---
 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 5341d72..0495453 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1177,7 +1177,7 @@ config SYSCTL
 config ANON_INODES
 	bool

-menuconfig EXPERT
+config EXPERT
 	bool "Configure standard kernel features (expert users)"
 	# Unhide debug options, to make the on-by-default options visible
 	select DEBUG_KERNEL
-- 
1.7.9.7


