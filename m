Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3BKJVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 04:21:23 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40506 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab3BKJVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 04:21:22 -0500
Date: Mon, 11 Feb 2013 14:48:56 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] uprobes/tracing: Kill uprobe_trace_consumer, embed
 uprobe_consumer into trace_uprobe
Message-ID: <20130211091856.GA525@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130131191752.GA30410@redhat.com>
 <20130131191829.GA30454@redhat.com>
 <20130204165945.GB4246@linux.vnet.ibm.com>
 <20130204172010.GA30749@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130204172010.GA30749@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021109-7182-0000-0000-0000051AFB33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-02-04 18:20:10]:
> 
> But so far I think that a chain of multiple consumers makes no sense.
> Each consumer->handler() will use the same call->perf_events list, this
> will only complicate the code for no reason.
> 
> > However with allowing prefiltering, we need to have ability to
> > distinguish consumers.
> 
> Certainly not. Please see the patches I am going to send.
> 

Yeah, Looking at the next patchset made me realize this. 

thanks

-- 
Thanks and Regards
Srikar Dronamraju

