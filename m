Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbaAIOYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:24:54 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:55457 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbaAIOUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:20:11 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 08/14] MAINTAINERS: add Bruce and myself to list of maintainers for file locking code
Date: Thu,  9 Jan 2014 09:19:41 -0500
Message-Id: <1389277187-18211-9-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
References: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
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
index 6c20792..ea43f99 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3410,6 +3410,8 @@ F:	include/uapi/scsi/fc/
 
 FILE LOCKING (flock() and fcntl()/lockf())
 M:	Matthew Wilcox <matthew@wil.cx>
+M:	Jeff Layton <jlayton@redhat.com>
+M:	J. Bruce Fields <bfields@fieldses.org>
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
 F:	include/linux/fcntl.h
-- 
1.8.4.2

