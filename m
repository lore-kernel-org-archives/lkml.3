Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaCFUzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:55:47 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:39974 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaCFUzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:55:45 -0500
Date: Thu, 6 Mar 2014 12:55:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [patch 00/11] userspace out of memory handling
In-Reply-To: <20140306204923.GF14033@htj.dyndns.org>
Message-ID: <alpine.DEB.2.02.1403061254240.25499@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com> <20140306204923.GF14033@htj.dyndns.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014, Tejun Heo wrote:

> On Tue, Mar 04, 2014 at 07:58:38PM -0800, David Rientjes wrote:
> > This patchset implements userspace out of memory handling.
> > 
> > It is based on v3.14-rc5.  Individual patches will apply cleanly or you
> > may pull the entire series from
> > 
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/rientjes/linux.git mm/oom
> > 
> > When the system or a memcg is oom, processes running on that system or
> > attached to that memcg cannot allocate memory.  It is impossible for a
> > process to reliably handle the oom condition from userspace.
> 
> ISTR the conclusion last time was nack on the whole approach.  What
> changed between then and now?  I can't detect any fundamental changes
> from the description.
> 

This includes system oom handling alongside memcg oom handling.  If you 
have specific objections, please let us know, thanks!
