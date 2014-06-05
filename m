Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaFEBMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 21:12:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:15287 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752833AbaFEBMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 21:12:07 -0400
X-Greylist: delayed 31551 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jun 2014 21:12:06 EDT
Date: Wed, 4 Jun 2014 21:12:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the ftrace tree
Message-ID: <20140604211202.0eb5d147@gandalf.local.home>
In-Reply-To: <20140605010353.GA13193@localhost>
References: <20140604160921.4f4e69c4@canb.auug.org.au>
	<20140604122612.366e2874@gandalf.local.home>
	<20140605002012.GA10446@localhost>
	<20140604210016.4766adba@gandalf.local.home>
	<20140605010353.GA13193@localhost>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2014 09:03:53 +0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> > Was I Cc'd? I don't have that in my inbox, nor do I see it in any of my
> > spam filters.
> 
> Yes, here is the email message:
> 
>         Date: Sat, 31 May 2014 02:16:43 +0800
>         From: kbuild test robot <fengguang.wu@intel.com>
> ==>     To: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Hmm, I wonder where it ended up? I do have a pretty complex procmailrc
file, but I even checked the procmail log file, and it doesn't show it.

I don't think my email provider dropped it, as I have all the spam
filtering turned off and do my own filtering. Although, they may have
added something behind my back. Wouldn't be the first time.

Are you sure that got sent?

Can you check if your bots have triggered anything else for me. Because
your bots have been surprisingly quiet lately. I just took that as me
getting better at not pushing crap.

I may add a bad commit to one of my branches and see if I get a
response from you just to test it out. I really hope we can fix this
because I've gotten someone dependent on your reports. :-/


-- Steve


>         CC: kbuild-all@01.org
>         Subject: [trace:ftrace/core 29/32] kernel/trace/trace_benchmark.c:38:6: warning: unused variable 'seedsq'
>         User-Agent: Heirloom mailx 12.5 6/20/10
> 
>         tree:   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git ftrace/core
>         head:   4c27e756bc019ec1c11232893af036fdae720a97
>         commit: 81dc9f0ef21e40114cc895894c7acf3055f6d1fb [29/32] tracing: Add tracepoint benchmark tracepoint
>         config: make ARCH=x86_64 allmodconfig
> 
>         All warnings:
> 
>            kernel/trace/trace_benchmark.c: In function 'trace_do_benchmark':
>         >> kernel/trace/trace_benchmark.c:38:6: warning: unused variable 'seedsq' [-Wunused-variable]
>              u64 seedsq;                                                                             
>                  ^
> Thanks,
> Fengguang

