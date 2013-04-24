Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab3DXOQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:16:30 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:45156
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148Ab3DXOQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:16:24 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 7/7] Tools: hv: Fix a checkpatch warning
Date: Wed, 24 Apr 2013 07:48:54 -0700
Message-Id: <1366814934-4461-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366814934-4461-1-git-send-email-kys@microsoft.com>
References: <1366814913-4422-1-git-send-email-kys@microsoft.com>
 <1366814934-4461-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a checkpatch warning.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 tools/hv/hv_vss_daemon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index 712cfc5..fea03a3 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -85,7 +85,7 @@ static int vss_operate(int operation)
 	if (mounts == NULL)
 		return -1;
 
-	while((ent = getmntent(mounts))) {
+	while ((ent = getmntent(mounts))) {
 		if (strncmp(ent->mnt_fsname, match, strlen(match)))
 			continue;
 		if (strcmp(ent->mnt_type, "iso9660") == 0)
-- 
1.7.4.1

