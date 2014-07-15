Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbaGOASv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 20:18:51 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:38814 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbaGOASs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 20:18:48 -0400
Date: Tue, 15 Jul 2014 05:48:38 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] tracing/uprobes: kill the dead
 TRACE_EVENT_FL_USE_CALL_FILTER logic
Message-ID: <20140715001838.GB23289@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140711190622.GA19499@redhat.com>
 <20140711190650.GA19537@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140711190650.GA19537@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071500-9264-0000-0000-000006928AD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2014-07-11 21:06:50]:

> alloc_trace_uprobe() sets TRACE_EVENT_FL_USE_CALL_FILTER for unknown
> reason and this is simply wrong. Fortunately this has no effect because
> register_uprobe_event() clears call->flags after that.
> 
> Kill both. This trace_uprobe was kzalloc'ed and we realy on this fact
> anyway.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju

