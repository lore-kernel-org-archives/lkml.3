Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab3JXKCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 06:02:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab3JXKCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 06:02:40 -0400
Date: Thu, 24 Oct 2013 11:04:15 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
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
Message-ID: <20131024100415.GB13223@kroah.com>
References: <20131024075813.GA26929@gmail.com>
 <1382604360.5283.9.camel@pippen.local.home>
 <CA+55aFxiNnpWSrA7GVHjsDsd6+a3XScDUAhpL7XPQ7F6g1-iJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxiNnpWSrA7GVHjsDsd6+a3XScDUAhpL7XPQ7F6g1-iJA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 10:42:37AM +0100, Linus Torvalds wrote:
> On Thu, Oct 24, 2013 at 9:46 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > But I agree, this should not be just dumped into the staging tree until
> > the patches themselves have been posted and reviewed.
> 
> Btw, it's not just the commit history. The actual file layout is
> terminally horrible too. The actual LWN article made it look like ktap
> was just a user-space tool, and I was thinking that it was like
> tools/pert/, just in staging.
> 
> But looking at the tree, it looks like parts of it is a kernel module,
> and parts of it is the user space thing, and it's totally impossible
> to see which is which, it's just all mixed up in the same directory
> structure.
> 
> Maybe I misunderstood, but that was my reaction from a very quick look.

No, you are correct, it is a mix and mess, and will be fixed up.

greg k-h
