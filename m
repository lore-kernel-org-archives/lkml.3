Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbaDWNrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:47:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56913 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974AbaDWNqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:46:54 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Al Viro <viro@zeniv.linux.org.uk>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 0/2] fs/ext4: fix for aio_write related kernel crash in linux-next
Date: Wed, 23 Apr 2014 16:46:44 +0300
Message-ID: <1398260806-19340-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This might be already fixed.
I have noticed that with linux-next the kernel crashes when trying to use ext4
as rootfs.

Regards,
Peter
---
Peter Ujfalusi (2):
  fs: read_write: Check ->aio_write in __kernel_write() and vfs_write()
  ext4: Fix up the .write callback to use new_sync_write

 fs/ext4/file.c  | 2 +-
 fs/read_write.c | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

-- 
1.9.2

