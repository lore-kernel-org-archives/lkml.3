Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbaBGRHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:07:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbaBGRHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:07:09 -0500
Date: Fri, 7 Feb 2014 18:07:08 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] memcg: charge path cleanups
Message-ID: <20140207170708.GI5121@dhcp22.suse.cz>
References: <1391792665-21678-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391792665-21678-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

The diffstat looks really nice. I will not get to the patches earlier
than on Monday.

> let me know what you think!
> 
> Johannes
> 

-- 
Michal Hocko
SUSE Labs
