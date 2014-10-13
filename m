Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaJMPOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:14:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952AbaJMPOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:14:38 -0400
Date: Mon, 13 Oct 2014 17:14:35 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 0/3] OOM vs. freezer interaction fixes
Message-ID: <20141013151435.GB15129@dhcp22.suse.cz>
References: <1412777266-8251-1-git-send-email-mhocko@suse.cz>
 <2107592.sy6uXko7kW@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2107592.sy6uXko7kW@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 09-10-14 00:11:33, Rafael J. Wysocki wrote:
> On Wednesday, October 08, 2014 04:07:43 PM Michal Hocko wrote:
> > Hi Andrew, Rafael,
> > 
> > this has been originally discussed here [1] but didn't lead anywhere AFAICS
> > so I would like to resurrect them.
> 
> OK
> 
> So any chance to CC linux-pm too next time?  There are people on that list
> who may be interested as well and are not in the CC directly either.

Sure, sorry about that! I've simply used the same CC list as the
previous post without realizing PM list was missing.

-- 
Michal Hocko
SUSE Labs
