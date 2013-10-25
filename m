Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab3JYKKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:10:12 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:41462 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3JYKKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:10:10 -0400
Date: Fri, 25 Oct 2013 12:10:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jovi.zhangwei@huawei.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: ktap inclusion in drivers/staging/?
Message-ID: <20131025101006.GA3439@gmail.com>
References: <20131024075813.GA26929@gmail.com>
 <1382604360.5283.9.camel@pippen.local.home>
 <CA+55aFxiNnpWSrA7GVHjsDsd6+a3XScDUAhpL7XPQ7F6g1-iJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxiNnpWSrA7GVHjsDsd6+a3XScDUAhpL7XPQ7F6g1-iJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Oct 24, 2013 at 9:46 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > But I agree, this should not be just dumped into the staging 
> > tree until the patches themselves have been posted and reviewed.
> 
> Btw, it's not just the commit history. The actual file layout is 
> terminally horrible too. The actual LWN article made it look like 
> ktap was just a user-space tool, and I was thinking that it was 
> like tools/pert/, just in staging.
> 
> But looking at the tree, it looks like parts of it is a kernel 
> module, and parts of it is the user space thing, and it's totally 
> impossible to see which is which, it's just all mixed up in the 
> same directory structure.
> 
> Maybe I misunderstood, but that was my reaction from a very quick 
> look.

Yes, that's what I saw as well. I'd be less worried about it all if 
it was tooling alone, but this is actually mostly kernel side code, 
which was not apparent at all to me either, from the structure of 
it.

Thanks,

	Ingo
