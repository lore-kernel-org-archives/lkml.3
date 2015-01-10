Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbbAJFGu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:06:50 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:36545
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbbAJFGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:06:48 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        vkuznets@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 1/5] Tools: hv: add mising fcopyd to the Makefile
Date: Fri,  9 Jan 2015 22:18:51 -0800
Message-Id: <1420870735-2265-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1420870690-2223-1-git-send-email-kys@microsoft.com>
References: <1420870690-2223-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

fcopyd in missing in the Makefile, add it there.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 tools/hv/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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
1.7.4.1

