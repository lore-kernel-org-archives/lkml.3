Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075AbaFRIuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:50:08 -0400
Received: from tundra.namei.org ([65.99.196.166]:41547 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933839AbaFRIuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:50:03 -0400
Date: Wed, 18 Jun 2014 18:51:39 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>, Greg KH <greg@kroah.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT] Add Serge Hallyn as security subsystem co-maintainer
Message-ID: <alpine.LRH.2.02.1406181850200.16097@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull.


The following changes since commit e99cfa2d0634881b8a41d56c48b5956b9a3ba162:

  Merge tag 'dt-fixes-for-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux (2014-06-17 14:25:09 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

James Morris (1):
      security: add Serge Hallyn as a maintainer

 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

---
commit 70b4a2598c4d88842c083eff7e28e8cc287bab5b
Author: James Morris <james.l.morris@oracle.com>
Date:   Wed Jun 18 18:57:50 2014 +1000

    security: add Serge Hallyn as a maintainer
    
    Add Serge E. Hallyn <serge@hallyn.com> as a co-maintainer of the
    security subsystem, to avoid having a single point of failure
    in the development process.
    
    Signed-off-by: James Morris <james.l.morris@oracle.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 134483f..e36d18d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7948,6 +7948,7 @@ F:	drivers/mmc/host/sdhci-spear.c
 
 SECURITY SUBSYSTEM
 M:	James Morris <james.l.morris@oracle.com>
+M:	Serge E. Hallyn <serge@hallyn.com>
 L:	linux-security-module@vger.kernel.org (suggested Cc:)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git
 W:	http://kernsec.org/

