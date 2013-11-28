Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089Ab3K1Leu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:34:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759038Ab3K1Lep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:34:45 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 23/29] tools lib traceevent: Harmonize the install messages in lib-traceevent
Date: Thu, 28 Nov 2013 12:33:22 +0100
Message-Id: <1385638408-23519-24-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
References: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing the 'to ...' part out of the install message,
because it does not fit to the rest of the build
messages we use.

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
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/lib/traceevent/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 19afd03..0d9cbb4 100644
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
-- 
1.8.3.1

