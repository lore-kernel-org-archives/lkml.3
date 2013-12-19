Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab3LSKGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:06:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab3LSKGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:06:18 -0500
Date: Thu, 19 Dec 2013 11:06:15 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>,
        Glauber Costa <glommer@gmail.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/6] memcg, slab: RCU protect memcg_params for root caches
Message-ID: <20131219100615.GD10855@dhcp22.suse.cz>
References: <6f02b2d079ffd0990ae335339c803337b13ecd8c.1387372122.git.vdavydov@parallels.com>
 <be8f2fede0fbc45496c06f7bc6cc2272b9b81cc4.1387372122.git.vdavydov@parallels.com>
 <20131219092836.GH9331@dhcp22.suse.cz>
 <52B2BE2A.2080509@parallels.com>
 <20131219094333.GB10855@dhcp22.suse.cz>
 <52B2C0B5.9010602@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B2C0B5.9010602@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 19-12-13 13:47:33, Vladimir Davydov wrote:
[...]
> Yeah, you're right, this longs for a documentation. I'm going to check

We desparately need a documentation for the life cycle of all involved
objects and description of which locks are used at which stage. 

> this code a bit more and try to write a good comment about it (although
> I'm rather poor at writing comments :-( )

A nice diagram would do as well...

Thanks!
-- 
Michal Hocko
SUSE Labs
