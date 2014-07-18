Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbaGRAt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 20:49:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55336 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759055AbaGRAtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 20:49:53 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 18 Jul 2014 10:48:28 +1000
Subject: [PATCH 5/5] autofs4: comment typo: remove a a doubled word.
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Kent <raven@themaw.net>
Message-ID: <20140718004828.19389.95882.stgit@notabene.brown>
In-Reply-To: <20140718004353.19389.48104.stgit@notabene.brown>
References: <20140718004353.19389.48104.stgit@notabene.brown>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/root.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index fb202cadd4b3..cdb25ebccc4c 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -377,7 +377,7 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
 		 * this because the leaves of the directory tree under the
 		 * mount never trigger mounts themselves (they have an autofs
 		 * trigger mount mounted on them). But v4 pseudo direct mounts
-		 * do need the leaves to to trigger mounts. In this case we
+		 * do need the leaves to trigger mounts. In this case we
 		 * have no choice but to use the list_empty() check and
 		 * require user space behave.
 		 */


