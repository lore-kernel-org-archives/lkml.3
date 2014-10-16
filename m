Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaJPPF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 11:05:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50192 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbaJPPF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 11:05:57 -0400
Date: Thu, 16 Oct 2014 17:05:53 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Bolle <pebolle@tiscali.nl>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Vladimir Davydov <vdavydov@parallels.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] kernel: res_counter: remove the unused API
Message-ID: <20141016150553.GA26234@dhcp22.suse.cz>
References: <1413251163-8517-1-git-send-email-hannes@cmpxchg.org>
 <1413251163-8517-4-git-send-email-hannes@cmpxchg.org>
 <1413444034.2128.27.camel@x220>
 <20141016112021.GC338@dhcp22.suse.cz>
 <20141016144641.GC9180@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016144641.GC9180@phnom.home.cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 16-10-14 10:46:41, Johannes Weiner wrote:
> On Thu, Oct 16, 2014 at 01:20:21PM +0200, Michal Hocko wrote:
> > On Thu 16-10-14 09:20:34, Paul Bolle wrote:
> > > On Mon, 2014-10-13 at 21:46 -0400, Johannes Weiner wrote:
> > > > All memory accounting and limiting has been switched over to the
> > > > lockless page counters.  Bye, res_counter!
> > > > 
> > > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > > > Acked-by: Vladimir Davydov <vdavydov@parallels.com>
> > > > Acked-by: Michal Hocko <mhocko@suse.cz>
> > > 
> > > This patch landed in today's linux-next (ie, next 20141016).
> > > 
> > > >  Documentation/cgroups/resource_counter.txt | 197 -------------------------
> > > >  include/linux/res_counter.h                | 223 -----------------------------
> > > >  init/Kconfig                               |   6 -
> > > >  kernel/Makefile                            |   1 -
> > > >  kernel/res_counter.c                       | 211 ---------------------------
> > > >  5 files changed, 638 deletions(-)
> > > >  delete mode 100644 Documentation/cgroups/resource_counter.txt
> > > >  delete mode 100644 include/linux/res_counter.h
> > > >  delete mode 100644 kernel/res_counter.c
> > > 
> > > There's a last reference to CONFIG_RESOURCE_COUNTERS in
> > > Documentation/cgroups/memory.txt. That reference could be dropped too,
> > > couldn't it?
> > ---
> > From a54e375e85c814199f480cb4ee7a133a395c5a00 Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.cz>
> > Date: Thu, 16 Oct 2014 13:15:24 +0200
> > Subject: [PATCH] kernel-res_counter-remove-the-unused-api-fix
> > 
> > ditch the last remainings of res_counter
> > 
> > Reported-by: Paul Bolle <pebolle@tiscali.nl>
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> 
> That makes sense, although that document is still littered with
> out-of-date and seemingly irrelevant information, which is why I
> didn't bother to update it.

I would also prefer to re-write or remove it long term.

-- 
Michal Hocko
SUSE Labs
