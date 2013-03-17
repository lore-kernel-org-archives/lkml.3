Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab3CQIjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 04:39:51 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:42315 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab3CQIjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 04:39:49 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v2 0/7] f2fs: Add tracepoints support in f2fs filesystem
Date: Sun, 17 Mar 2013 17:39:27 +0900
Message-Id: <1363509567-3469-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add tracepoints in f2fs filesystem for tracing the filesystem
operations for information/debugging purpose if needed. All the 
tracepoints are clubbed with respect to functionalities.

 Namjae Jeon(7):
  f2fs: add tracepoints for sync operations and inode operations
  f2fs: add tracepoints for truncate operation
  f2fs: add tracepoint for tracing the page i/o operations
  f2fs: add tracepoints for GC threads
  f2fs: add tracepoints to debug the block allocation and fallocate
  f2fs: add tracepoints for write page operations
  f2fs: add tracepoints to debug checkpoint request
-- 
1.7.9.5

