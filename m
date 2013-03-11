Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab3CKHOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:14:42 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:26678 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab3CKHOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:14:38 -0400
Message-ID: <513D8452.6050600@huawei.com>
Date: Mon, 11 Mar 2013 15:14:26 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH 13/13] scsi/tracing: make scsi_trace.c depend on CONFIG_EVENT_TRACING
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make scsi_trace.c only compile on the condition of CONFIG_EVENT_TRACING

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 drivers/scsi/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index b607ba4..aab9ade 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -168,7 +168,7 @@ scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
 scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
-scsi_mod-y			+= scsi_trace.o
+scsi_mod-$(CONFIG_EVENT_TRACING)+= scsi_trace.o
 scsi_mod-$(CONFIG_PM)		+= scsi_pm.o

 hv_storvsc-y			:= storvsc_drv.o
-- 
1.7.9.7


