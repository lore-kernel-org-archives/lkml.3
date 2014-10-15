Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaJOJkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:40:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbaJOJke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:40:34 -0400
Date: Wed, 15 Oct 2014 11:40:31 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: memcontrol: lockless page counters
Message-ID: <20141015094031.GC23547@dhcp22.suse.cz>
References: <1413251163-8517-1-git-send-email-hannes@cmpxchg.org>
 <1413251163-8517-2-git-send-email-hannes@cmpxchg.org>
 <20141014155647.GA6414@dhcp22.suse.cz>
 <20141014163354.GA23911@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141014163354.GA23911@phnom.home.cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 14-10-14 12:33:54, Johannes Weiner wrote:
> On Tue, Oct 14, 2014 at 05:56:47PM +0200, Michal Hocko wrote:
[...]
> > You have only missed MAINTAINERS...
> 
> Hm, we can add it, but then again scripts/get_maintainer.pl should
> already do the right thing.

OK, that would work as well.
-- 
Michal Hocko
SUSE Labs
