Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3AZR2v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 12:28:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab3AZR2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 12:28:33 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 9/9] perf: Document the ABI for 'rdpmc' sysfs attribute
Date: Sat, 26 Jan 2013 18:27:55 +0100
Message-Id: <1359221275-24254-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1359221275-24254-1-git-send-email-jolsa@redhat.com>
References: <1359221275-24254-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding ABI documentation for newly added 'rdpmc' sysfs
attribute. It's added under the testing section.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
---
 .../ABI/testing/sysfs-bus-event_source-devices-cpu-rdpmc          | 8 ++++++++
 1 file changed, 8 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-cpu-rdpmc

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-cpu-rdpmc b/Documentation/ABI/testing/sysfs-bus-event_source-devices-cpu-rdpmc
new file mode 100644
index 0000000..b4f5cbf
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-cpu-rdpmc
@@ -0,0 +1,8 @@
+Where:		/sys/bus/event_source/devices/cpu/rdpmc
+Date:		January 2013
+Kernel Version:	3.7
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:
+		X86 specific attribute
+
+		Attribute to enable/disable user space RDPMC instruction.
-- 
1.7.11.7

