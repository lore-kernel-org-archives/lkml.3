Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118Ab3BHOrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:47:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34342 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab3BHOrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:47:22 -0500
Date: Fri, 8 Feb 2013 15:47:20 +0100
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH for 3.2.34] memcg: do not trigger OOM if PF_NO_MEMCG_OOM
 is set
Message-ID: <20130208144720.GC7557@dhcp22.suse.cz>
References: <20130205160934.GB22804@dhcp22.suse.cz>
 <20130206021721.1AE9E3C7@pobox.sk>
 <20130206140119.GD10254@dhcp22.suse.cz>
 <20130206142219.GF10254@dhcp22.suse.cz>
 <20130206160051.GG10254@dhcp22.suse.cz>
 <20130208060304.799F362F@pobox.sk>
 <20130208094420.GA7557@dhcp22.suse.cz>
 <20130208120249.FD733220@pobox.sk>
 <20130208123854.GB7557@dhcp22.suse.cz>
 <20130208145616.FB78CE24@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208145616.FB78CE24@pobox.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 08-02-13 14:56:16, azurIt wrote:
> Data are inside memcg-bug-5.tar.gz in directories bug/<timestamp>/<pids>/

ohh, I didn't get those were timestamp directories. It makes more sense
now.
-- 
Michal Hocko
SUSE Labs
