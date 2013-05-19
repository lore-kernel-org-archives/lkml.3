Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab3ESPEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 11:04:45 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:40903 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab3ESPEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 11:04:43 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, koverstreet@google.com,
        rob@landley.net, linux-doc@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] doc: Fix typo in documentation/bcache.txt
Date: Mon, 20 May 2013 00:04:35 +0900
Message-Id: <1368975875-1380-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.3.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in documentation/bcache.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>

# Please enter the commit message for your changes. Lines starting
# with '#' will be kept; you may remove them yourself if you want to.
# An empty message aborts the commit.
# On branch bcache-fix
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#	modified:   Documentation/bcache.txt
#
---
 Documentation/bcache.txt | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/bcache.txt b/Documentation/bcache.txt
index b3a7e7d..c3365f2 100644
--- a/Documentation/bcache.txt
+++ b/Documentation/bcache.txt
@@ -181,7 +181,7 @@ want for getting the best possible numbers when benchmarking.
 
    In practice this isn't an issue because as soon as a write comes along it'll
    cause the btree node to be split, and you need almost no write traffic for
-   this to not show up enough to be noticable (especially since bcache's btree
+   this to not show up enough to be noticeable (especially since bcache's btree
    nodes are huge and index large regions of the device). But when you're
    benchmarking, if you're trying to warm the cache by reading a bunch of data
    and there's no other traffic - that can be a problem.
@@ -222,7 +222,7 @@ running
   it's in passthrough mode or caching).
 
 sequential_cutoff
-  A sequential IO will bypass the cache once it passes this threshhold; the
+  A sequential IO will bypass the cache once it passes this threshold; the
   most recent 128 IOs are tracked so sequential IO can be detected even when
   it isn't all done at once.
 
@@ -296,7 +296,7 @@ cache_miss_collisions
   since the synchronization for cache misses was rewritten)
 
 cache_readaheads
-  Count of times readahead occured.
+  Count of times readahead occurred.
 
 SYSFS - CACHE SET:
 
@@ -362,7 +362,7 @@ unregister
 SYSFS - CACHE SET INTERNAL:
 
 This directory also exposes timings for a number of internal operations, with
-separate files for average duration, average frequency, last occurence and max
+separate files for average duration, average frequency, last occurrence and max
 duration: garbage collection, btree read, btree node sorts and btree splits.
 
 active_journal_entries
@@ -417,7 +417,7 @@ freelist_percent
   space.
 
 io_errors
-  Number of errors that have occured, decayed by io_error_halflife.
+  Number of errors that have occurred, decayed by io_error_halflife.
 
 metadata_written
   Sum of all non data writes (btree writes and all other metadata).
-- 
1.8.3.rc3

