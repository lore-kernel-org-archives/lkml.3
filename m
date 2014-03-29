Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaC2RCt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 13:02:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaC2RCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 13:02:47 -0400
Date: Sat, 29 Mar 2014 10:04:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 07/28] ktap: add runtime/ktap.[c|h]
Message-ID: <20140329170445.GD31707@kroah.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
 <1396014469-5937-8-git-send-email-jovi.zhangwei@gmail.com>
 <87ha6inp7g.fsf@tassilo.jf.intel.com>
 <CAGdX0WFMXejHjhy5sVkVuQvNwE8MevEuAsDbkAZCb35mJj07zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdX0WFMXejHjhy5sVkVuQvNwE8MevEuAsDbkAZCb35mJj07zQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 03:32:12PM +0800, Jovi Zhangwei wrote:
> >> +struct syscall_metadata **syscalls_metadata;
> >> +
> >> +/*TODO: kill this function in future */
> >> +static int __init init_dummy_kernel_functions(void)
> >> +{
> >> +     unsigned long *addr;
> >> +
> >> +     /*
> >> +      * ktap need symbol ftrace_profile_set_filter to set event filter,
> >> +      * export it in future.
> >
> > Obviously you need to fix that. Just export the symbols.
> >
> Yeah, will do after kernel community decide to merge ktap. :)

We already said we wanted it merged, so please send patches that do it
properly, by exporting the needed symbols as part of the patch series.

thanks,

greg k-h
