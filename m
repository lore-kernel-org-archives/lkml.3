Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaCFVEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:04:34 -0500
Received: from mail-yk0-f173.google.com ([209.85.160.173]:39603 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaCFVEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:04:31 -0500
Date: Thu, 6 Mar 2014 16:04:27 -0500
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
Subject: Re: [patch 04/11] mm, memcg: add tunable for oom reserves
Message-ID: <20140306210427.GH14033@htj.dyndns.org>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1403041955050.8067@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403041955050.8067@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 07:59:19PM -0800, David Rientjes wrote:
> Userspace needs a way to define the amount of memory reserves that
> processes handling oom conditions may utilize.  This patch adds a per-
> memcg oom reserve field and file, memory.oom_reserve_in_bytes, to
> manipulate its value.
> 
> If currently utilized memory reserves are attempted to be reduced by
> writing a smaller value to memory.oom_reserve_in_bytes, it will fail with
> -EBUSY until some memory is uncharged.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

We're completely unsure this is the way we wanna be headed and this is
a huge commitment.  For now at least,

Nacked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
