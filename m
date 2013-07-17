Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750797Ab3GQAps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 20:45:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab3GQApq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 20:45:46 -0400
Date: Tue, 16 Jul 2013 17:45:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamal Mostafa <kamal@canonical.com>
Cc: Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kernel-team@lists.ubuntu.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [ 3.8.y.z extended stable ] Patch
 "memcg, kmem: fix reference count handling on the error path" has been
 added to staging queue
Message-Id: <20130716174548.f34bc75e.akpm@linux-foundation.org>
In-Reply-To: <1374018009.3225.123.camel@fourier>
References: <1374015242-28112-1-git-send-email-kamal@canonical.com>
	<20130716160658.fc30d70b5230aab5b3b3950b@linux-foundation.org>
	<1374018009.3225.123.camel@fourier>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013 16:40:09 -0700 Kamal Mostafa <kamal@canonical.com> wrote:

> On Tue, 2013-07-16 at 16:06 -0700, Andrew Morton wrote:
> > On Tue, 16 Jul 2013 15:54:02 -0700 Kamal Mostafa <kamal@canonical.com> wrote:
> > 
> > > This is a note to let you know that I have just added a patch titled
> > > 
> > >     memcg, kmem: fix reference count handling on the error path
> > > 
> > > to the linux-3.8.y-queue branch of the 3.8.y.z extended stable tree 
> > > which can be found at:
> > 
> > hm, why.
> 
> Because it said "Cc: <stable@vger.kernel.org> [3.8]", making me think
> the author specifically wanted it to be applied to 3.8-stable.

Damn, so it did, sorry.  Your version removed that line.

I don't know why I did that - afaict problems can only occur when
kmalloc(GFP_KERNEL) fails, and that's exceedingly unlikely.

> > Now, I will freely admit that I may have made a mistake.  But please be
> > aware that you are taking a path which I have already considered and
> > rejected.  So a little extra care is warranted for akpm patches, please.
> 
> I'll try to watch out for them.

Thanks.
