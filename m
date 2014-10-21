Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351AbaJULte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:49:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170AbaJULtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:49:32 -0400
Message-ID: <54464844.8040402@redhat.com>
Date: Tue, 21 Oct 2014 13:49:24 +0200
From: =?windows-1252?Q?Matej_Mu=9Eila?= <mmuzila@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: kys@microsoft.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] tools: hv: fcopy_daemon: Unused variable removed
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matej Mužila <mmuzila@redhat.com>

Remove unused variable

Signed-off-by: Matej Mužila <mmuzila@redhat.com>
Acked-by:  K. Y. Srinivasan <kys@microsoft.com>
---
diff --git a/tools/hv/hv_fcopy_daemon.c b/tools/hv/hv_fcopy_daemon.c
index 6f27e2f..1fc2dc2 100644
--- a/tools/hv/hv_fcopy_daemon.c
+++ b/tools/hv/hv_fcopy_daemon.c
@@ -132,7 +132,7 @@ static int hv_copy_cancel(void)
 
 int main(void)
 {
-	int fd, fcopy_fd, len;
+	int fcopy_fd, len;
 	int error;
 	int version = FCOPY_CURRENT_VERSION;
 	char *buffer[4096 * 2];

