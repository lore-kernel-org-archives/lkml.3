Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900AbaELPVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:21:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758468AbaELPV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:21:28 -0400
Date: Mon, 12 May 2014 17:21:27 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org
Subject: Re: [PATCH 02/14] cgroup: remove pointless has tasks/children test
 from mem_cgroup_force_empty()
Message-ID: <20140512152127.GI9564@dhcp22.suse.cz>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-3-git-send-email-tj@kernel.org>
 <20140512145324.GE9564@dhcp22.suse.cz>
 <20140512145927.GA1421@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512145927.GA1421@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 12-05-14 10:59:27, Tejun Heo wrote:
[...]
> Can I roll this into my series so that I can put this before changes
> which depend on direct ->children usages being removed?

Sure
-- 
Michal Hocko
SUSE Labs
