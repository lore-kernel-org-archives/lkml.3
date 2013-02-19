Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab3BSCcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:32:45 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64277 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab3BSCco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:32:44 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 0/8] f2fs: Add tracepoints support in f2fs filesystem
Date: Tue, 19 Feb 2013 11:32:33 +0900
Message-Id: <1361241153-18005-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add tracepoints in f2fs filesystem for tracing the filesystem
operations for information/debugging purpose if needed. All the 
tracepoints are clubbed with respect to functionalities.

 Namjae Jeon(8):
  f2fs: add tracepoints for sync operations
  f2fs: add tracepoints for inode operations
  f2fs: add tracepoints for truncate operation
  f2fs: add tracepoint for tracing the page i/o operations
  f2fs: add tracepoints for GC threads
  f2fs: add tracepoints to debug the block allocation and fallocate
  f2fs: add tracepoints for write page operations
  f2fs: add tracepoints to debug checkpoint request
-- 
1.7.9.5

