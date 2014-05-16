Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbaEPOFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:05:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:28851 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757091AbaEPOFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:05:06 -0400
Message-Id: <20140516140215.149535442@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 16 May 2014 10:02:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/4] tools lib traceevent: bitmask handling and plugin updates
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

I see that you ported some of the plugin code to traceevent library.
Along with the update to the __get_bitmask() patch I included 3 patches that
I did not too long ago that added some more features to the plugin code
that trace-cmd has. I'm working on more but the structure is a bit different
and I'm trying to make them in sync again.

-- Steve


Steven Rostedt (Red Hat) (4):
      tools lib traceevent: Add flag to not load event plugins
      tools lib traceevent: Add options to plugins
      tools lib traceevent: Add options to function plugin
      tools lib traceevent: Added support for __get_bitmask() macro

----
 tools/lib/traceevent/event-parse.c                 | 113 ++++++++++++
 tools/lib/traceevent/event-parse.h                 |  23 ++-
 tools/lib/traceevent/event-plugin.c                | 204 ++++++++++++++++++++-
 tools/lib/traceevent/plugin_function.c             |  43 ++++-
 .../perf/util/scripting-engines/trace-event-perl.c |   1 +
 .../util/scripting-engines/trace-event-python.c    |   1 +
 6 files changed, 375 insertions(+), 10 deletions(-)
