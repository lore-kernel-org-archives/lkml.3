Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773AbaJ3TaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:30:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47330 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaJ3TaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:30:13 -0400
Date: Thu, 30 Oct 2014 20:30:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Sasha Levin <sasha.levin@oracle.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        riel@redhat.com, linux-mm@kvack.org
Subject: Re: [PATCH] mm: initialize variable for mem_cgroup_end_page_stat
Message-ID: <20141030193005.GX12706@worktop.programming.kicks-ass.net>
References: <1414633464-19419-1-git-send-email-sasha.levin@oracle.com>
 <20141030082712.GB4664@dhcp22.suse.cz>
 <54523DDE.9000904@oracle.com>
 <20141030141401.GA24520@phnom.home.cmpxchg.org>
 <54524A2F.5050907@oracle.com>
 <20141030153159.GA3639@dhcp22.suse.cz>
 <20141030172632.GA25217@phnom.home.cmpxchg.org>
 <20141030174241.GD3639@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030174241.GD3639@dhcp22.suse.cz>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 06:42:41PM +0100, Michal Hocko wrote:
> Well, I would use a typedef to obfuscate those values because nobody
> except for mem_cgroup_{begin,end}_page_stat should touch them. But we
> are not doing typedefs in kernel...

$ git grep typedef | wc -l
11379
