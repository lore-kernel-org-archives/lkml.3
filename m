Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530Ab3GSBcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 21:32:19 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46568 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752916Ab3GSBcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 21:32:18 -0400
Message-ID: <1374197536.1949.138.camel@joe-AO722>
Subject: [PATCH] docproc: Move printk file location
From: Joe Perches <joe@perches.com>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, kbuild-all@01.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 18 Jul 2013 18:32:16 -0700
In-Reply-To: <51e893c9.vV8XainIvStpRwPf%fengguang.wu@intel.com>
References: <51e893c9.vV8XainIvStpRwPf%fengguang.wu@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> docproc: kernel/printk.c: No such file or directory

So rename the file.

Signed-off-by: Joe Perches <joe@perches.com>
Noticed-by: kbuild test robot <fengguang.wu@intel.com>
---
 Documentation/DocBook/device-drivers.tmpl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index cbfdf54..fe397f9 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -84,7 +84,7 @@ X!Iinclude/linux/kobject.h
 
      <sect1><title>Kernel utility functions</title>
 !Iinclude/linux/kernel.h
-!Ekernel/printk.c
+!Ekernel/printk/printk.c
 !Ekernel/panic.c
 !Ekernel/sys.c
 !Ekernel/rcupdate.c


