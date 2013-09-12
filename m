Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab3ILUzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:55:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57849 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab3ILUy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:54:59 -0400
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, trivial@vger.kernel.org
Cc: patches@linaro.org, Sebastian Capella <sebastian.capella@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Warren <swarren@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] init/do_mounts.c: add maj:min syntax comment
Date: Thu, 12 Sep 2013 13:54:54 -0700
Message-Id: <1379019294-14636-1-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name_to_dev_t function has a comment block which lists the
supported syntaxes for the device name.  Add a bullet for
the <major>:<minor> syntax, which is already supported in the code

Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 init/do_mounts.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 816014c..89dc3a6 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -195,6 +195,8 @@ done:
  *	   is a zero-filled hex representation of the 1-based partition number.
  *	7) PARTUUID=<UUID>/PARTNROFF=<int> to select a partition in relation to
  *	   a partition with a known unique id.
+ *	8) <major>:<minor> major and minor number of the device separated by
+ *	   a colon.
  *
  *	If name doesn't have fall into the categories above, we return (0,0).
  *	block_class is used to check if something is a disk name. If the disk
-- 
1.7.9.5

