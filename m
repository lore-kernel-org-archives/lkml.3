Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaJTQXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:23:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaJTQXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:23:30 -0400
Subject: [PATCH] audit: add Paul Moore to the MAINTAINERS entry
From: Paul Moore <pmoore@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org, eparis@redhat.com
Date: Mon, 20 Oct 2014 12:23:28 -0400
Message-ID: <20141020162328.1159.33576.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a long stint maintaining the audit tree, Eric asked me to step
in and handle the day-to-day management of the audit tree.  We should
also update the linux-audit mailing list entry to better reflect
current usage.

Signed-off-by: Paul Moore <pmoore@redhat.com>
---
 MAINTAINERS |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c2066f4..86c24fd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1689,10 +1689,11 @@ S:	Supported
 F:	drivers/scsi/esas2r
 
 AUDIT SUBSYSTEM
+M:	Paul Moore <paul@paul-moore.com>
 M:	Eric Paris <eparis@redhat.com>
-L:	linux-audit@redhat.com (subscribers-only)
+L:	linux-audit@redhat.com (moderated for non-subscribers)
 W:	http://people.redhat.com/sgrubb/audit/
-T:	git git://git.infradead.org/users/eparis/audit.git
+T:	git git://git.infradead.org/users/pcmoore/audit
 S:	Maintained
 F:	include/linux/audit.h
 F:	include/uapi/linux/audit.h

