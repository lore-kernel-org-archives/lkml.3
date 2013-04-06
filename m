Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab3DFFpg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 01:45:36 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:37037 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3DFFpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 01:45:34 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v3 0/7] f2fs: add tracepoints support in f2fs filesystem
Date: Sat,  6 Apr 2013 14:45:26 +0900
Message-Id: <1365227126-15355-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add tracepoints in f2fs filesystem for tracing the filesystem
operations for information/debugging purpose if needed. All the
tracepoints are clubbed with respect to functionalities.

Change Log:
v3: Introduced TRACE_EVENT_CONDITION() macro for checking the
condition page->mapping inside the trace point function call as
per Steve's review comment for the patch

v2: Added DECLARE_EVENT_CLASS() macro for combining the similar
type of trace function calls which has same type of arguments.

v1: Introduced the tracepoint functions in f2fs filesystem.

Namjae Jeon (7):
  f2fs: add tracepoints for sync & Inode operations
  f2fs: add tracepoints for truncate operation
  f2fs: add tracepoint for tracing the page i/o operations
  f2fs: add tracepoints for GC threads
  f2fs: add tracepoints to debug the block allocation & fallocate
  f2fs: add tracepoints for write page operations
  f2fs: add tracepoints to debug checkpoint request

-- 
1.7.9.5

