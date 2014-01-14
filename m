Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaANTNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:13:41 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:64701 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaANTNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:13:38 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 08/14] MAINTAINERS: add Bruce and myself to list of maintainers for file locking code
Date: Tue, 14 Jan 2014 14:06:48 -0500
Message-Id: <1389726414-30990-9-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389726414-30990-1-git-send-email-jlayton@redhat.com>
References: <1389726414-30990-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both Bruce and I have done a fair bit of work in these files recently,
and would like to be notified if anyone is proposing changes to it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Acked-by: "J. Bruce Fields" <bfields@fieldses.org>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 31a0462..6062c15 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3412,6 +3412,8 @@ F:	include/uapi/scsi/fc/
 
 FILE LOCKING (flock() and fcntl()/lockf())
 M:	Matthew Wilcox <matthew@wil.cx>
+M:	Jeff Layton <jlayton@redhat.com>
+M:	J. Bruce Fields <bfields@fieldses.org>
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
 F:	include/linux/fcntl.h
-- 
1.8.4.2

