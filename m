Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaKDIjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:39:42 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52362 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaKDIjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:39:40 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <545890B5.3020102@jp.fujitsu.com>
Date: Tue, 4 Nov 2014 17:39:17 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>,
        Tejun Heo <tj@kernel.org>, David Miller <davem@davemloft.net>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/3] mm: move page->mem_cgroup bad page handling into
 generic code
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org> <1414898156-4741-3-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1414898156-4741-3-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/02 12:15), Johannes Weiner wrote:
> Now that the external page_cgroup data structure and its lookup is
> gone, let the generic bad_page() check for page->mem_cgroup sanity.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


