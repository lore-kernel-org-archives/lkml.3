Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab3LJJc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:32:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44251 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3LJJSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:18:49 -0500
Date: Tue, 10 Dec 2013 01:18:15 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-f33c5cd73172c4fb81daa83a4f6d322210172fa0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1386076182-14484-7-git-send-email-jolsa@redhat.com>
References: <1386076182-14484-7-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Harmonize the install messages in lib-traceevent
Git-Commit-ID: f33c5cd73172c4fb81daa83a4f6d322210172fa0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:18:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f33c5cd73172c4fb81daa83a4f6d322210172fa0
Gitweb:     http://git.kernel.org/tip/f33c5cd73172c4fb81daa83a4f6d322210172fa0
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 3 Dec 2013 14:09:20 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 15:19:09 -0300

tools lib traceevent: Harmonize the install messages in lib-traceevent

Removing the 'to ...' part out of the install message, because it does
not fit to the rest of the build messages we use.

Before:
  INSTALL  plugin_hrtimer.so    to      /home/jolsa/libexec/perf-core/traceevent/plugins
  INSTALL  plugin_jbd2.so       to      /home/jolsa/libexec/perf-core/traceevent/plugins
  INSTALL  plugin_kmem.so       to      /home/jolsa/libexec/perf-core/traceevent/plugins
  INSTALL  plugin_kvm.so        to      /home/jolsa/libexec/perf-core/traceevent/plugins
  INSTALL  plugin_mac80211.so   to      /home/jolsa/libexec/perf-core/traceevent/plugins
  INSTALL  plugin_sched_switch.so       to      /home/jolsa/libexec/perf-core/traceevent/plugins
  INSTALL  plugin_function.so   to      /home/jolsa/libexec/perf-core/traceevent/plugins
  INSTALL  plugin_xen.so        to      /home/jolsa/libexec/perf-core/traceevent/plugins
  INSTALL  plugin_scsi.so       to      /home/jolsa/libexec/perf-core/traceevent/plugins

Now:
  INSTALL  plugin_jbd2.so
  INSTALL  plugin_hrtimer.so
  INSTALL  plugin_kmem.so
  INSTALL  plugin_kvm.so
  INSTALL  plugin_mac80211.so
  INSTALL  plugin_sched_switch.so
  INSTALL  plugin_function.so
  INSTALL  plugin_xen.so
  INSTALL  plugin_scsi.so

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386076182-14484-7-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 1526798..f946851 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -166,7 +166,7 @@ else
   print_plugin_obj_compile =	echo '  CC FPIC  '$(OBJ);
   print_plugin_build =		echo '  BUILD    PLUGIN '$(OBJ);
   print_static_lib_build =	echo '  BUILD    STATIC LIB '$(OBJ);
-  print_install =		echo '  INSTALL  '$1'	to	$(DESTDIR_SQ)$2';
+  print_install =		echo '  INSTALL  '$1;
 endif
 
 do_fpic_compile =					\
