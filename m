Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760512Ab3GaR7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 13:59:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13449 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab3GaR7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:59:52 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=fDhLNHh0KZQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6No3EKuEBNEA:10 a=Y3HfltMrH2vKsfhgqBEA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375293591.5418.9.camel@gandalf.local.home>
Subject: Re: [PATCH v2 0/1] tracing: trace_remove_event_call() should fail
 if call/file is in use
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 31 Jul 2013 13:59:51 -0400
In-Reply-To: <20130731173832.GA31099@redhat.com>
References: <20130729175008.GA26284@redhat.com>
	 <1375289503.5418.6.camel@gandalf.local.home>
	 <20130731173832.GA31099@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-31 at 19:38 +0200, Oleg Nesterov wrote:
> On 07/31, Steven Rostedt wrote:
> >
> > On Mon, 2013-07-29 at 19:50 +0200, Oleg Nesterov wrote:
> > >
> > > Now we are ready to change trace_kprobe.c and trace_uprobe.c, Steven
> > > already has the patches.
> >
> > Can you refresh my memory. My INBOX is quite full. What were the
> > subjects for these patches?
> 
> Please see the attached mbox. And notice who is the author ;)

Heh, who is that guy?

> I also added the ack from Masami.

Thanks, but I'll take in from the email as that's how my scripts work (I
cc'd myself)

-- Steve

> 
> But if you only need the subjects:
> 
> 	[RFC][PATCH 3/4] tracing/kprobes: Fail to unregister if probe event files are open
> 	[RFC][PATCH 4/4] tracing/uprobes: Fail to unregister if probe event files are open
> 
> Oleg.


