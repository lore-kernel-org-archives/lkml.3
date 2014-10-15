Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaJOUx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:53:57 -0400
Received: from mail.kernel.org ([198.145.19.201]:35621 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbaJOUxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:53:55 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/15] perf Documentation: Fix typos in perf/Documentation
Date: Wed, 15 Oct 2014 17:52:46 -0300
Message-Id: <1413406368-26245-14-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413406368-26245-1-git-send-email-acme@kernel.org>
References: <1413406368-26245-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masanari Iida <standby24x7@gmail.com>

This patch fix spelling typos found in tool/perf/Documentation.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Randy Dunlap <rdunlap@infradead.org>
Link: http://lkml.kernel.org/r/1410275930-17207-1-git-send-email-standby24x7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index b3b8abae62b8..e463caa3eb49 100644
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
index 6e689dc89a2f..6252e776009c 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -100,7 +100,7 @@ OPTIONS
 STAT REPORT OPTIONS
 -------------------
 --vcpu=<value>::
-       analyze events which occures on this vcpu. (default: all vcpus)
+       analyze events which occur on this vcpu. (default: all vcpus)
 
 --event=<value>::
        event to be analyzed. Possible values: vmexit, mmio (x86 only),
@@ -134,7 +134,7 @@ STAT LIVE OPTIONS
     Analyze events only for given process ID(s) (comma separated list).
 
 --vcpu=<value>::
-       analyze events which occures on this vcpu. (default: all vcpus)
+       analyze events which occur on this vcpu. (default: all vcpus)
 
 
 --event=<value>::
diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 6fce6a622206..cbb4f743d921 100644
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
index d460049cae8e..398f8d53bd6d 100644
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
index d00bef231340..dfbb506d2c34 100644
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
index 9f1f054b8432..54acba221558 100644
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
index 05f9a0a6784c..5a0160d359a1 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -140,7 +140,7 @@ OPTIONS
     
 		"Overriding previous field request for all events."
     
-	Alternativey, consider the order:
+	Alternatively, consider the order:
     
 		-f comm,tid,time,ip,sym -f trace:
     
diff --git a/tools/perf/Documentation/perf-test.txt b/tools/perf/Documentation/perf-test.txt
index d1d3e5121f89..31a5c3ea7f74 100644
--- a/tools/perf/Documentation/perf-test.txt
+++ b/tools/perf/Documentation/perf-test.txt
@@ -25,7 +25,7 @@ OPTIONS
 -------
 -s::
 --skip::
-	Tests to skip (comma separater numeric list).
+	Tests to skip (comma separated numeric list).
 
 -v::
 --verbose::
diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 02aac831bdd9..7e1b1f2bb83c 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -20,7 +20,7 @@ scheduling events, etc.
 This is a live mode tool in addition to working with perf.data files like
 the other perf tools. Files can be generated using the 'perf record' command
 but the session needs to include the raw_syscalls events (-e 'raw_syscalls:*').
-Alernatively, the 'perf trace record' can be used as a shortcut to
+Alternatively, 'perf trace record' can be used as a shortcut to
 automatically include the raw_syscalls events when writing events to a file.
 
 The following options apply to perf trace; options to perf trace record are
-- 
1.9.3

