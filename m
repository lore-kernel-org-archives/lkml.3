Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaCFVda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:33:30 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:57585 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbaCFVd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:33:28 -0500
Date: Thu, 6 Mar 2014 16:33:24 -0500
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [patch 00/11] userspace out of memory handling
Message-ID: <20140306213324.GG17902@htj.dyndns.org>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
 <20140306204923.GF14033@htj.dyndns.org>
 <alpine.DEB.2.02.1403061254240.25499@chino.kir.corp.google.com>
 <20140306205911.GG14033@htj.dyndns.org>
 <alpine.DEB.2.02.1403061301020.25499@chino.kir.corp.google.com>
 <20140306211136.GA17902@htj.dyndns.org>
 <alpine.DEB.2.02.1403061312020.25499@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403061312020.25499@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bit of addition.

On Thu, Mar 06, 2014 at 01:23:57PM -0800, David Rientjes wrote:
> This patchset provides a solution to a real-world problem that is not 
> solved with any other patchset.  I expect it to be reviewed as any other 
> patchset, it's not an "RFC" from my perspective: it's a proposal for 
> inclusion.  Don't worry, Andrew is not going to apply anything 
> accidentally.

I can't force it down your throat but I feel somewhat uneasy about how
this was posted without any reference to the previous discussion as if
this were just now being proposed especially as the said discussion
wasn't particularly favorable to this approach.  Prefixing RFC or at
least pointing back to the original discussion seems like the
courteous thing to do.

Thanks.

-- 
tejun
