Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab3BESNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:13:24 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:39200 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335Ab3BESNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:13:23 -0500
Date: Tue, 5 Feb 2013 13:13:11 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 2/3] memcg: move memcg_stock initialization to
 mem_cgroup_init
Message-ID: <20130205181311.GB993@cmpxchg.org>
References: <1360081441-1960-1-git-send-email-mhocko@suse.cz>
 <1360081441-1960-3-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360081441-1960-3-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 05:24:00PM +0100, Michal Hocko wrote:
> memcg_stock are currently initialized during the root cgroup allocation
> which is OK but it pointlessly pollutes memcg allocation code with
> something that can be called when the memcg subsystem is initialized by
> mem_cgroup_init along with other controller specific parts.
> 
> This patch wrappes the current memcg_stock initialization code into a
> helper calls it from the controller subsystem initialization code.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
