Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaLBJWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:22:24 -0500
Received: from hofr.at ([212.69.189.236]:53604 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbaLBJWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:22:18 -0500
Date: Tue, 2 Dec 2014 10:16:47 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] clarification of _shipped files intent
Message-ID: <20141202091647.GF13909@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


clarification of _shipped files intent

The rational for using _shipped files should be clearly
indicated so that it does not look like it is encouraging
binary blobs.

This patch is against linux 3.18.0-rc6

Note that the original file uses leading tabs so for this
patch this was retained.

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 Documentation/kbuild/modules.txt |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/kbuild/modules.txt b/Documentation/kbuild/modules.txt
index 450af1f..eeca125 100644
--- a/Documentation/kbuild/modules.txt
+++ b/Documentation/kbuild/modules.txt
@@ -268,7 +268,10 @@ module 8123.ko, which is built from the following files:
 
 --- 3.3 Binary Blobs
 
-	Some external modules need to include an object file as a blob.
+	Some external modules need to include an object file as a
+	prebuilt binary if they depend on exotic tools or if the
+	build time penalty of generating such files might be seen
+	to be too high.
 	kbuild has support for this, but requires the blob file to be
 	named <filename>_shipped. When the kbuild rules kick in, a copy
 	of <filename>_shipped is created with _shipped stripped off,
-- 
1.7.10.4

