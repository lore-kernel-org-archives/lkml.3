Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab3DLVTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 17:19:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9522 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab3DLVTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 17:19:50 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=od9ufGozyBcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=B5pM2mQJZ68A:10 a=a7VecAXSKk6aXWWA83oA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365801588.9609.95.camel@gandalf.local.home>
Subject: Re: [PATCH 0/1] uprobes/tracing: Don't pass addr=ip to
 perf_trace_buf_submit()
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Date: Fri, 12 Apr 2013 17:19:48 -0400
In-Reply-To: <20130411115921.GA27492@redhat.com>
References: <20130329181520.GA20670@redhat.com>
	 <20130329181545.GA20697@redhat.com>
	 <20130404142522.GC8986@linux.vnet.ibm.com> <515E4938.6090809@hitachi.com>
	 <20130405150110.GA31300@redhat.com> <51628DF8.6030102@hitachi.com>
	 <20130410145818.GA30670@redhat.com> <516692BF.6070904@hitachi.com>
	 <20130411115921.GA27492@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 13:59 +0200, Oleg Nesterov wrote:

> > If so, we can do same thing also on trace_events.
> > (perf_trace_##call in include/trace/ftrace.h)
> 
> Yes, yes, this is not kprobe-specific. It seems that more users of
> perf_trace_buf_submit() could be changed the same way.
> 

Oleg,

Can you make the necessary changes elsewhere? I talked with Frederic on
IRC and he's a bit busy with other work. But he did say he would review
changes that you make.

Thanks,

-- Steve


