Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058AbaLAXXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:23:53 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:51214 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932700AbaLAXXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:23:51 -0500
Date: Mon, 1 Dec 2014 18:23:43 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Qiang Huang <h.huangqiang@huawei.com>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, oom: remove gfp helper function
Message-ID: <20141201232343.GA29642@phnom.home.cmpxchg.org>
References: <alpine.DEB.2.10.1411261416480.13014@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1411261416480.13014@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 02:17:32PM -0800, David Rientjes wrote:
> Commit b9921ecdee66 ("mm: add a helper function to check may oom
> condition") was added because the gfp criteria for oom killing was
> checked in both the page allocator and memcg.
> 
> That was true for about nine months, but then commit 0029e19ebf84 ("mm:
> memcontrol: remove explicit OOM parameter in charge path") removed the
> memcg usecase.
> 
> Fold the implementation into its only caller.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
