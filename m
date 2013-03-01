Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab3CALWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 06:22:37 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:41211 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab3CALWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 06:22:35 -0500
X-AuditID: cbfec7f5-b7fd76d000007247-1f-51308f793316
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Matthias Fend <matthias.fend@wolfvision.net>
Subject: [PATCH] tools/usb: adapt ffs-test.c to new layout of includes (UAPI)
Date: Fri, 01 Mar 2013 12:21:41 +0100
Message-id: <1362136901-28645-1-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNJMWRmVeSWpSXmKPExsVy+t/xa7qV/QaBBk+2mVlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MB690CppYK15Nr21gXMnSxcjJISFgIvH9304mCFtM4sK99Wxd
	jFwcQgJLGSU271zJBOFsYJLYuXYHG0gVm4CxxN6DHYwgtoiAgsTm3mesIEXMAjOZJC7tXARW
	JCzgK/F68USwFSwCqhK7fv9nBrF5BVwl1h14yQixTl7i6f0+tgmM3AsYGVYxiqaWJhcUJ6Xn
	GukVJ+YWl+al6yXn525ihHjw6w7GpcesDjEKcDAq8fAGVukHCrEmlhVX5h5ilOBgVhLh/d9o
	ECjEm5JYWZValB9fVJqTWnyIkYmDU6qBkeNDxNH5O9ODlJy+dL43zZdh+HMwsWrfPJGgpT+P
	x1te6ey7H8701ve69EaN6XdDjH8mvT0adDFn/rlrPkyfNuzSyGYv7/o0XfjRlisisgu6Z7xU
	69Qo+JKa5vPg2PPYnJfhs9Z8Opgzy6DMw4HjdN7bqQwhi36VFbbzXc/scH6VUWEUOiGpQoml
	OCPRUIu5qDgRAFjML6G+AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 tools/usb/ffs-test.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
index 8674b9e..fe1e66b 100644
--- a/tools/usb/ffs-test.c
+++ b/tools/usb/ffs-test.c
@@ -38,7 +38,7 @@
 #include <unistd.h>
 #include <tools/le_byteshift.h>
 
-#include "../../include/linux/usb/functionfs.h"
+#include "../../include/uapi/linux/usb/functionfs.h"
 
 
 /******************** Little Endian Handling ********************************/
-- 
1.7.0.4

