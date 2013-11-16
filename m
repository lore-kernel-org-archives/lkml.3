Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3KPUhm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 15:37:42 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:65114 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab3KPUhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 15:37:36 -0500
Message-ID: <5287D78D.4070601@linux.com>
Date: Sat, 16 Nov 2013 21:37:33 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: AFS list <linux-afs@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Levente Kurusa <levex@linux.com>
Subject: [PATCH] afs: dir: remove unused label out_skip
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The out_skip label is not used, so remove it.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 fs/afs/dir.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 3756d4f..0e10b14 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -669,7 +669,6 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)

 out_valid:
 	dentry->d_fsdata = dir_version;
-out_skip:
 	dput(parent);
 	key_put(key);
 	_leave(" = 1 [valid]");
