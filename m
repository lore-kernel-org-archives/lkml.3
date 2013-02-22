Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab3BVNAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 08:00:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756872Ab3BVNAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 08:00:19 -0500
Date: Fri, 22 Feb 2013 14:00:17 +0100
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH for 3.2.34] memcg: do not trigger OOM if PF_NO_MEMCG_OOM
 is set
Message-ID: <20130222130017.GB32285@dhcp22.suse.cz>
References: <20130222125217.GA32285@dhcp22.suse.cz>
 <20130222135442.ADFFF498@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130222135442.ADFFF498@pobox.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 22-02-13 13:54:42, azurIt wrote:
> >I am not sure how much time I'll have for this today but just to make
> >sure we are on the same page, could you point me to the two patches you
> >have applied in the mean time?
> 
> 
> Here:
> http://watchdog.sk/lkml/patches2

OK, looks correct.

-- 
Michal Hocko
SUSE Labs
