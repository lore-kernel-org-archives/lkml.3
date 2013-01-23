Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab3AWAff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:35:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3AWAfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:35:32 -0500
Date: Tue, 22 Jan 2013 16:35:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 1/6] cgroup: initialize cgrp->dentry before css_alloc()
Message-Id: <20130122163526.6c4ea765.akpm@linux-foundation.org>
In-Reply-To: <20130123002754.GB5359@htj.dyndns.org>
References: <50F7B040.2020906@huawei.com>
	<20130123002754.GB5359@htj.dyndns.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2013 16:27:54 -0800
Tejun Heo <tj@kernel.org> wrote:

> (cc'ing Andrew as scheduler folks are difficult to get response from
>  these days and I can't think of anyone else to bother :)
> 
> Hello, Li.
> 
> The cgroup part looks good to me but it would be great if the
> descriptions are more detailed, especially, about why the change is
> beneficial or what it's aiming at.  I take it that the shed changes
> are necessary to facilitate the later cgroup changes?  Can you please
> elaborate how?
> 
> The scheduler part of changes are mostly mechanical, so it would be
> great if we can get ack from scheduler people and route these together.
> 

The sched parts do look pretty innocuous and could be viewed as "cgroup
stuff which happens to reside in kernel/sched/".

If you like the code, I think the best you can do is to merge it up,
make sure the sched guys are fully cc'ed then send it in to Linus.
