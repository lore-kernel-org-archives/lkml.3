Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaIJQ6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:58:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:43888 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbaIJQ6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:58:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,500,1406617200"; 
   d="scan'208";a="600953121"
Message-ID: <54108314.80400@intel.com>
Date: Wed, 10 Sep 2014 09:57:56 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave@sr71.net>
CC: Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: regression caused by cgroups optimization in 3.17-rc2
References: <54061505.8020500@sr71.net> <5406262F.4050705@intel.com> <54062F32.5070504@sr71.net> <20140904142721.GB14548@dhcp22.suse.cz> <5408CB2E.3080101@sr71.net> <20140905092537.GC26243@dhcp22.suse.cz> <20140910162936.GI25219@dhcp22.suse.cz>
In-Reply-To: <20140910162936.GI25219@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 09:29 AM, Michal Hocko wrote:
> I do not have a bigger machine to play with unfortunately. I think the
> patch makes sense on its own. I would really appreciate if you could
> give it a try on your machine with !root memcg case to see how much it
> helped. I would expect similar results to your previous testing without
> the revert and Johannes' patch.

So you want to see before/after this patch:

Subject: [PATCH] mm, memcg: Do not kill release batching in
 free_pages_and_swap_cache

And you want it on top of a kernel with the revert or without?
