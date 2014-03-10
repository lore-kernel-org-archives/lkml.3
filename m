Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaCJPz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:55:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36326 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705AbaCJPzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:55:24 -0400
Date: Mon, 10 Mar 2014 16:55:23 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] memcg: charge path cleanups
Message-ID: <20140310155523.GF5171@dhcp22.suse.cz>
References: <1391792665-21678-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391792665-21678-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 07-02-14 12:04:17, Johannes Weiner wrote:
> Hi Michal,
> 
> I took some of your patches and combined them with the charge path
> cleanups I already had and the changes I made after our discussion.
> 
> I'm really happy about where this is going:
> 
>  mm/memcontrol.c | 298 ++++++++++++++++--------------------------------------
>  1 file changed, 87 insertions(+), 211 deletions(-)
> 
> let me know what you think!
> 
> Johannes
 
What's happened with this series? Are you planning to repost it
Johannes? I know it is late in the cycle but it would be nice to have it
at least in mmotm tree because it shuffles the code a lot.

-- 
Michal Hocko
SUSE Labs
