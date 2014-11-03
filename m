Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaKCRcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:32:52 -0500
Received: from mx2.parallels.com ([199.115.105.18]:57287 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaKCRct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:32:49 -0500
Date: Mon, 3 Nov 2014 20:32:41 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Tejun Heo <tj@kernel.org>, David Miller <davem@davemloft.net>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/3] mm: move page->mem_cgroup bad page handling into
 generic code
Message-ID: <20141103173241.GW17258@esperanza>
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
 <1414898156-4741-3-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1414898156-4741-3-git-send-email-hannes@cmpxchg.org>
X-Originating-IP: [81.5.99.36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 11:15:56PM -0400, Johannes Weiner wrote:
> Now that the external page_cgroup data structure and its lookup is
> gone, let the generic bad_page() check for page->mem_cgroup sanity.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Vladimir Davydov <vdavydov@parallels.com>
