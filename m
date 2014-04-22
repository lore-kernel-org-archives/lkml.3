Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbaDVVOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:14:36 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:55900 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757716AbaDVVOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:14:31 -0400
Date: Tue, 22 Apr 2014 17:14:26 -0400
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Daniel Borkmann <dborkman@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Rohit Jnagal <jnagal@google.com>,
        Brandon Philips <brandon.philips@coreos.com>
Subject: Re: [PATCH v2 cgroup/for-3.16] cgroup: add documentation about
 unified hierarchy
Message-ID: <20140422211426.GD3615@mtj.dyndns.org>
References: <20140414220917.GD1863@htj.dyndns.org>
 <20140416145248.GD1257@htj.dyndns.org>
 <20140422162707.GR29311@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422162707.GR29311@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Hope you enjoyed the vacation. :)

On Tue, Apr 22, 2014 at 06:27:07PM +0200, Michal Hocko wrote:
> On Wed 16-04-14 10:52:48, Tejun Heo wrote:
> [....]
> > +The memory controller currently doesn't have a way to control what
> > +happens between internal tasks and child cgroups and the behavior is
> > +not clearly defined. 
> 
> I am not sure I understand this. Could you be more specific what exactly
> is not clearly defined?

Oh, the fact that there are no control knobs for the internal tasks,
so when there's contention involving both internal tasks and child
cgroups, how resources are distributed is implementation specific
without clearly defined rules.

Thanks.

-- 
tejun
