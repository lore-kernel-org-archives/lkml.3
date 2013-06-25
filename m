Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab3FYIQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:16:20 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:5852 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3FYIQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:16:16 -0400
Message-ID: <51C951AB.5050201@huawei.com>
Date: Tue, 25 Jun 2013 16:15:39 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 0/2] tracing/kprobes&uprobes: some change on unregister logic
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset change some logic on events unregistering of kprobes/uprobes

patch 1: kprobes event unregister cleanup
patch 2: fix a bug when calling unregister trace_uprobe

zhangwei(Jovi) (2):
  tracing/kprobes: move free_trace_probe into unregister_trace_probe
  tracing/uprobes: disallow unregister trace_uprobe when trace_uprobe
    is in use

 kernel/trace/trace_kprobe.c |    5 +----
 kernel/trace/trace_uprobe.c |   51 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 39 insertions(+), 17 deletions(-)

-- 
1.7.9.7


