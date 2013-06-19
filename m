Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934151Ab3FSCtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 22:49:52 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:53158 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933861Ab3FSCtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 22:49:51 -0400
MIME-Version: 1.0
Date: Wed, 19 Jun 2013 10:49:50 +0800
Message-ID: <CAPgLHd8ycujfKpt4zd-AXyg2J4uRAGREO_YjaGba+rLgQQ40uA@mail.gmail.com>
Subject: [PATCH -next] dlm: remove duplicated include from lowcomms.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: ccaulfie@redhat.com, teigland@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/dlm/lowcomms.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 4f539dd..d90909e 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -52,7 +52,6 @@
 #include <linux/mutex.h>
 #include <linux/sctp.h>
 #include <linux/slab.h>
-#include <linux/sctp.h>
 #include <net/sctp/sctp.h>
 #include <net/ipv6.h>
 

