Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaFMCL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 22:11:59 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:28365 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751313AbaFMCL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 22:11:58 -0400
Message-Id: <20140613021002.444608350@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 12 Jun 2014 22:10:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 0/4] tools lib tracing: Updates from trace-cmd for plugin_kvm
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

I'm synchronizing the changes that is in trace-cmd and the traceevent
library. I found a few updates that are missing from the kvm plugin.

-- Steve



Jan Kiszka (3):
      tools lib traceevent: Report unknown VMX exit reasons with code
      tools lib traceevent: Factor out print_exit_reason in kvm plugin
      tools lib traceevent: Fix and cleanup kvm_nested_vmexit tracepoints

Steven Rostedt (Red Hat) (1):
      tools lib traceevent: Add back in kvm plugin's nested_vmexit events

----
 tools/lib/traceevent/plugin_kvm.c | 64 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 56 insertions(+), 8 deletions(-)
