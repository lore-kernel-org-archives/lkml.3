Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316AbaJaTCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 15:02:51 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:60602 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaJaTCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 15:02:49 -0400
Date: Fri, 31 Oct 2014 20:02:42 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ovl: initialize ->is_cursor
Message-ID: <20141031190242.GA19099@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
This goes on top of "ovl: fix check for cursor".

 fs/overlayfs/readdir.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -93,6 +93,7 @@ static struct ovl_cache_entry *ovl_cache
 		p->type = d_type;
 		p->ino = ino;
 		p->is_whiteout = false;
+		p->is_cursor = false;
 	}
 
 	return p;

