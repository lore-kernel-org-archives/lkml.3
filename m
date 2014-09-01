Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaIADqk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 23:46:40 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:57202 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaIADqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 23:46:39 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, linux-kernel@vger.kernel.org
Cc: rdunlap@infradead.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] perf/documentation: Fix typo in perf/Documentation
Date: Mon,  1 Sep 2014 12:46:22 +0900
Message-Id: <1409543182-19589-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.0.24.g4109c28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix spelling typo found in tool/perf/Documentation.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 tools/perf/Documentation/perf-diff.txt          | 6 +++---
 tools/perf/Documentation/perf-kvm.txt           | 4 ++--
 tools/perf/Documentation/perf-list.txt          | 2 +-
 tools/perf/Documentation/perf-record.txt        | 2 +-
 tools/perf/Documentation/perf-script-perl.txt   | 4 ++--
 tools/perf/Documentation/perf-script-python.txt | 6 +++---
 tools/perf/Documentation/perf-script.txt        | 2 +-
 tools/perf/Documentation/perf-test.txt          | 2 +-
 tools/perf/Documentation/perf-trace.txt         | 2 +-
 9 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index b3b8aba..e463caa 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -196,10 +196,10 @@ If specified the 'Weighted diff' column is displayed with value 'd' computed as:
 
   - period being the hist entry period value
 
-  - WEIGHT-A/WEIGHT-B being user suplied weights in the the '-c' option
+  - WEIGHT-A/WEIGHT-B being user supplied weights in the the '-c' option
     behind ':' separator like '-c wdiff:1,2'.
-    - WIEGHT-A being the weight of the data file
-    - WIEGHT-B being the weight of the baseline data file
+    - WEIGHT-A being the weight of the data file
+    - WEIGHT-B being the weight of the baseline data file
 
 SEE ALSO
 --------
diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index 6e689dc..6039eb0 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -100,7 +100,7 @@ OPTIONS
 STAT REPORT OPTIONS
 -------------------
 --vcpu=<value>::
-       analyze events which occures on this vcpu. (default: all vcpus)
+       analyze events which occurres on this vcpu. (default: all vcpus)
 
 --event=<value>::
        event to be analyzed. Possible values: vmexit, mmio (x86 only),
@@ -134,7 +134,7 @@ STAT LIVE OPTIONS
     Analyze events only for given process ID(s) (comma separated list).
 
 --vcpu=<value>::
-       analyze events which occures on this vcpu. (default: all vcpus)
+       analyze events which occurres on this vcpu. (default: all vcpus)
 
 
 --event=<value>::
diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 6fce6a6..cbb4f74 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -19,7 +19,7 @@ various perf commands with the -e option.
 EVENT MODIFIERS
 ---------------
 
-Events can optionally have a modifer by appending a colon and one or
+Events can optionally have a modifier by appending a colon and one or
 more modifiers. Modifiers allow the user to restrict the events to be
 counted. The following modifiers exist:
 
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index d460049..398f8d5 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -146,7 +146,7 @@ the thread executes on the designated CPUs. Default is to monitor all CPUs.
 
 -N::
 --no-buildid-cache::
-Do not update the builid cache. This saves some overhead in situations
+Do not update the buildid cache. This saves some overhead in situations
 where the information in the perf.data file (which includes buildids)
 is sufficient.
 
diff --git a/tools/perf/Documentation/perf-script-perl.txt b/tools/perf/Documentation/perf-script-perl.txt
index d00bef2..dfbb506 100644
--- a/tools/perf/Documentation/perf-script-perl.txt
+++ b/tools/perf/Documentation/perf-script-perl.txt
@@ -181,8 +181,8 @@ strings for flag and symbolic fields.  These correspond to the strings
 and values parsed from the 'print fmt' fields of the event format
 files:
 
-  flag_str($event_name, $field_name, $field_value) - returns the string represention corresponding to $field_value for the flag field $field_name of event $event_name
-  symbol_str($event_name, $field_name, $field_value) - returns the string represention corresponding to $field_value for the symbolic field $field_name of event $event_name
+  flag_str($event_name, $field_name, $field_value) - returns the string representation corresponding to $field_value for the flag field $field_name of event $event_name
+  symbol_str($event_name, $field_name, $field_value) - returns the string representation corresponding to $field_value for the symbolic field $field_name of event $event_name
 
 Perf::Trace::Context Module
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/tools/perf/Documentation/perf-script-python.txt b/tools/perf/Documentation/perf-script-python.txt
index 9f1f054..54acba2 100644
--- a/tools/perf/Documentation/perf-script-python.txt
+++ b/tools/perf/Documentation/perf-script-python.txt
@@ -263,7 +263,7 @@ and having the counts we've tallied as values.
 
 The print_syscall_totals() function iterates over the entries in the
 dictionary and displays a line for each entry containing the syscall
-name (the dictonary keys contain the syscall ids, which are passed to
+name (the dictionary keys contain the syscall ids, which are passed to
 the Util function syscall_name(), which translates the raw syscall
 numbers to the corresponding syscall name strings).  The output is
 displayed after all the events in the trace have been processed, by
@@ -576,8 +576,8 @@ strings for flag and symbolic fields.  These correspond to the strings
 and values parsed from the 'print fmt' fields of the event format
 files:
 
-  flag_str(event_name, field_name, field_value) - returns the string represention corresponding to field_value for the flag field field_name of event event_name
-  symbol_str(event_name, field_name, field_value) - returns the string represention corresponding to field_value for the symbolic field field_name of event event_name
+  flag_str(event_name, field_name, field_value) - returns the string representation corresponding to field_value for the flag field field_name of event event_name
+  symbol_str(event_name, field_name, field_value) - returns the string representation corresponding to field_value for the symbolic field field_name of event event_name
 
 The *autodict* function returns a special kind of Python
 dictionary that implements Perl's 'autovivifying' hashes in Python
diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 05f9a0a..5a0160d 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -140,7 +140,7 @@ OPTIONS
     
 		"Overriding previous field request for all events."
     
-	Alternativey, consider the order:
+	Alternatively, consider the order:
     
 		-f comm,tid,time,ip,sym -f trace:
     
diff --git a/tools/perf/Documentation/perf-test.txt b/tools/perf/Documentation/perf-test.txt
index d1d3e5121..9fc5c5d 100644
--- a/tools/perf/Documentation/perf-test.txt
+++ b/tools/perf/Documentation/perf-test.txt
@@ -25,7 +25,7 @@ OPTIONS
 -------
 -s::
 --skip::
-	Tests to skip (comma separater numeric list).
+	Tests to skip (comma separator numeric list).
 
 -v::
 --verbose::
diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 02aac83..524c169 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -20,7 +20,7 @@ scheduling events, etc.
 This is a live mode tool in addition to working with perf.data files like
 the other perf tools. Files can be generated using the 'perf record' command
 but the session needs to include the raw_syscalls events (-e 'raw_syscalls:*').
-Alernatively, the 'perf trace record' can be used as a shortcut to
+Alternatively, the 'perf trace record' can be used as a shortcut to
 automatically include the raw_syscalls events when writing events to a file.
 
 The following options apply to perf trace; options to perf trace record are
-- 
2.1.0.24.g4109c28

