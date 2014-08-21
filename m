Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaHURpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:45:30 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:46065 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaHURp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:45:29 -0400
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com E4A05821FE
Date: Thu, 21 Aug 2014 11:45:25 -0600
From: Andrea Righi <andrea@betterlinux.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Heaton <matt@betterlinux.com>
Subject: Re: [PATCH] cgroup: add tracepoints to track cgroup events
Message-ID: <20140821174525.GC7625@Dell>
References: <1408592785-6700-1-git-send-email-andrea@betterlinux.com>
 <20140821141330.GA1766@mtj.dyndns.org>
 <20140821153541.GA7625@Dell>
 <20140821170002.GB7625@Dell>
 <20140821170701.GA3940@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821170701.GA3940@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 12:07:01PM -0500, Tejun Heo wrote:
...
> > I still need to figure out a smart way to track which PIDs are
> > added/removed to/from cgroup.procs from userland (inotifywait + git? :)),
> > but all the other informations provided by my tracepoint patch seem to
> > be already available via [di]notify.
> 
> Hmmm... yeah, determining exactly which pids got added / removed can
> be cumbersome from just MODIFY events.  That said, what are you trying
> to do with such information?

Just trying to figure out if a particular application/pid is moved too
much across different cgroups, or collect per-pid / per-cgroup
statistics in general.

Thanks,
-Andrea
