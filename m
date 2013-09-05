Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763615Ab3IEMp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:45:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761641Ab3IEMpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:45:24 -0400
Date: Thu, 5 Sep 2013 14:45:23 +0200
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] improve memcg oom killer robustness v2
Message-ID: <20130905124523.GC13666@dhcp22.suse.cz>
References: <20130904115741.GA28285@dhcp22.suse.cz>
 <20130904141000.0F910EFA@pobox.sk>
 <20130904122632.GB28285@dhcp22.suse.cz>
 <20130905111430.CB1392B4@pobox.sk>
 <20130905095331.GA9702@dhcp22.suse.cz>
 <20130905121700.546B5881@pobox.sk>
 <20130905111742.GC9702@dhcp22.suse.cz>
 <20130905134702.C703F65B@pobox.sk>
 <20130905120347.GA13666@dhcp22.suse.cz>
 <20130905143343.AF56A889@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905143343.AF56A889@pobox.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 05-09-13 14:33:43, azurIt wrote:
[...]
> >Just to be sure I got you right. You have killed all the processes from
> >the group you have sent stacks for, right? If that is the case I am
> >really curious about processes sitting in sleep_on_page_killable because
> >those are killable by definition.
> 
> Yes, my script killed all of that processes right after taking
> stack.

OK, _after_ part is important. Has the group gone away after then?
-- 
Michal Hocko
SUSE Labs
