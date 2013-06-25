Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab3FYDhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 23:37:36 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:22562 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab3FYDhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 23:37:35 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Jun 2013 23:37:34 EDT
Message-ID: <51C90EC0.1070206@huawei.com>
Date: Tue, 25 Jun 2013 11:30:08 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH 0/2 v3] tracing/uprobes: Support multibuffer and soft-mode
 disabling
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is third version of uprobes-based dynamic events
multibuffer and soft-mode disabling support work.

[v3]:
1. separate soft-mode disabling patch from multibuffer support patch.
2. fix some comments
3. coding style trivial
4. fix flags race in probe_event_disable


zhangwei(Jovi) (2):
  tracing/uprobes: Support ftrace_event_file base multibuffer
  tracing/uprobes: Support soft-mode disabling

 kernel/trace/trace_uprobe.c |  121 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 100 insertions(+), 21 deletions(-)

-- 
1.7.9.7


