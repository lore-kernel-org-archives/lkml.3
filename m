Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab3HFIH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:07:27 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:65057 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab3HFIHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:07:24 -0400
Message-ID: <5200AE50.2010108@huawei.com>
Date: Tue, 6 Aug 2013 16:05:36 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <ebiederm@xmission.com>
CC: <kexec@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH] kexec: remove unnecessary return
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code can not run here forever, so remove the unnecessary return.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 kernel/kexec.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 59f7b55..c14e3ea 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1477,8 +1477,6 @@ static int __init __parse_crashkernel(char *cmdline,
 	else
 		return parse_crashkernel_simple(ck_cmdline, crash_size,
 				crash_base);
-
-	return 0;
 }
 
 /*
-- 
1.7.1

