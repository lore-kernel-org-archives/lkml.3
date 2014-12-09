Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbaLIPsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 10:48:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757101AbaLIPse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 10:48:34 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
Subject: [PATCH 1/5] Tools: hv: add mising fcopyd to the Makefile
Date: Tue,  9 Dec 2014 16:48:19 +0100
Message-Id: <1418140103-11854-2-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1418140103-11854-1-git-send-email-vkuznets@redhat.com>
References: <1418140103-11854-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fcopyd in missing in the Makefile, add it there.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/hv/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/hv/Makefile b/tools/hv/Makefile
index bd22f78..99ffe61 100644
--- a/tools/hv/Makefile
+++ b/tools/hv/Makefile
@@ -5,9 +5,9 @@ PTHREAD_LIBS = -lpthread
 WARNINGS = -Wall -Wextra
 CFLAGS = $(WARNINGS) -g $(PTHREAD_LIBS)
 
-all: hv_kvp_daemon hv_vss_daemon
+all: hv_kvp_daemon hv_vss_daemon hv_fcopy_daemon
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $^
 
 clean:
-	$(RM) hv_kvp_daemon hv_vss_daemon
+	$(RM) hv_kvp_daemon hv_vss_daemon hv_fcopy_daemon
-- 
1.9.3

