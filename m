Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab3FRCCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 22:02:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19506 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab3FRCCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 22:02:04 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=OjN0HKCXvREA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=DnkOc9KbUqAA:10 a=tSAWcc6Xqgn2ay_OORwA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371520921.18733.28.camel@gandalf.local.home>
Subject: Re: Re: [PATCH] tracing/uprobes: Support ftrace_event_file base
 multibuffer
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: paulmck@linux.vnet.ibm.com, "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Date: Mon, 17 Jun 2013 22:02:01 -0400
In-Reply-To: <51BFB878.10508@hitachi.com>
References: <51BA7578.4080108@huawei.com> <51BB18EB.9080307@hitachi.com>
	  <1371223918.9844.324.camel@gandalf.local.home>
	  <20130614162112.GO5146@linux.vnet.ibm.com>
	  <1371227607.9844.335.camel@gandalf.local.home>
	  <20130614172516.GP5146@linux.vnet.ibm.com> <51BE7A83.9060802@hitachi.com>
	 <1371472393.18733.5.camel@gandalf.local.home> <51BFB878.10508@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-18 at 10:31 +0900, Masami Hiramatsu wrote:
> (2013/06/17 21:33), Steven Rostedt wrote:

> > The only reason ftrace function tracer uses the raw (and now
> > raw_notrace) version is because it is extremely invasive, and these
> > checks done at *every* function call can actually live lock the system.
> > But other places in tracing use the appropriate rcu_dereference_*()
> > functions. If they do not, then they need to be fixed too.
> 
> Oh, I see.
> Anyway, it will be completely replaced by the Oleg's patch.
> Or should I fix that before his work?

It's not that urgent. If Oleg's patch will replace it, I wouldn't
bother.

-- Steve


