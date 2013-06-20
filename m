Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab3FTRmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 13:42:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757030Ab3FTRmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 13:42:23 -0400
Date: Thu, 20 Jun 2013 19:37:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] tracing/kprobes: perf_trace_buf_*() optimization +
	cleanups
Message-ID: <20130620173748.GA13133@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

Please consider this series for inclusion. It doesn't depend on
other changes we are discussing.

Only cosmetic changes since v1, everything was acked by Masami.

Oleg.

 kernel/trace/trace_kprobe.c |  187 ++++++++++++++-----------------------------
 1 files changed, 61 insertions(+), 126 deletions(-)

