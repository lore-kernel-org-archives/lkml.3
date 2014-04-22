Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbaDVTyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:54:22 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:45508 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756776AbaDVTyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:54:19 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8WAGjIVlNXQyNO/2dsb2JhbABZgwaCXoEGp3qZYgICgRUXdIJmHCMYgQIkE4hFAc0ujXJkhD8BA45rigQBimuHZ4MzO4Es
Date: Tue, 22 Apr 2014 21:56:17 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ian Kent <raven@themaw.net>, akpm <akpm@linux-foundation.org>,
        autofs@vger.kernel.org
Subject: [PATCH 1/1] fs/autofs4/dev-ioctl.c: add __init to
 autofs_dev_ioctl_init
Message-Id: <20140422215617.1646f3bb2fd7d159d268def2@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

autofs_dev_ioctl_init is only called by __init init_autofs4_fs

Cc: Ian Kent <raven@themaw.net>
Cc: autofs@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/autofs4/dev-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 232e03d..5b570b6 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -737,7 +737,7 @@ MODULE_ALIAS_MISCDEV(AUTOFS_MINOR);
 MODULE_ALIAS("devname:autofs");
 
 /* Register/deregister misc character device */
-int autofs_dev_ioctl_init(void)
+int __init autofs_dev_ioctl_init(void)
 {
 	int r;
 
-- 
1.8.4.5

