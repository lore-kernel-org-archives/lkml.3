Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab3LGRlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 12:41:20 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:45097 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383Ab3LGRlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 12:41:16 -0500
Date: Sat, 7 Dec 2013 12:40:39 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tim Hockin <thockin@hockin.org>
Cc: Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] mm, memcg: allow processes handling oom
 notifications to access reserves
Message-ID: <20131207174039.GH21724@cmpxchg.org>
References: <20131128115458.GK2761@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312021504170.13465@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1312032118570.29733@chino.kir.corp.google.com>
 <20131204054533.GZ3556@cmpxchg.org>
 <alpine.DEB.2.02.1312041742560.20115@chino.kir.corp.google.com>
 <20131205025026.GA26777@htj.dyndns.org>
 <alpine.DEB.2.02.1312051537550.7717@chino.kir.corp.google.com>
 <20131206173438.GE21724@cmpxchg.org>
 <CAAAKZwsh3erB7PyG6FnvJRgrZhf2hDQCZDx3rMM7NdOdYNCzJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAKZwsh3erB7PyG6FnvJRgrZhf2hDQCZDx3rMM7NdOdYNCzJw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tim!

On Sat, Dec 07, 2013 at 08:38:20AM -0800, Tim Hockin wrote:
> We actually started with kernel patches all h these lines - per-memcg
> scores and all of our crazy policy requirements.
> 
> It turns out that changing policies is hard.
>
> When David offered the opportunity to manage it all in user space it
> sounded like a great idea.
> 
> If this can be made to work as a high prio daemon with access to reserves,
> we would like it.

We can not talk solutions if you won't describe the problem.  It's
understandable that you can't talk about internal details, but it's
possible to describe a technical problem in a portable fashion such
that people can understand and evaluate it without knowing your whole
application.  Companies do this all the time.

"The way our blackbox works makes it really hard to hook it up to the
Linux kernel" is not a very convincing technical argument to change
the Linux kernel.

Thanks!
