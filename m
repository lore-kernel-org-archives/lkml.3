Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbaF3SWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:22:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:14334 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754486AbaF3SWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:22:15 -0400
Date: Mon, 30 Jun 2014 14:22:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] tracing/uprobes: Fix the usage of
 uprobe_buffer_enable() in probe_event_enable()
Message-ID: <20140630142207.17e9985c@gandalf.local.home>
In-Reply-To: <20140630175836.GB21918@redhat.com>
References: <20140627170116.GA18298@redhat.com>
	<20140627170146.GA18332@redhat.com>
	<20140630170409.GD5619@linux.vnet.ibm.com>
	<20140630132126.5479795e@gandalf.local.home>
	<20140630175836.GB21918@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014 19:58:36 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> But I won't insist, this is subjective. So please let me know if you still
> think it would be better to add this change, I'll send v2.

Don't bother. I didn't look at the patch in context to make that reply.
I think your original patch looks better than the alternative. I'll
keep it as is.

Thanks,

-- Steve
