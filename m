Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaBGVGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 16:06:49 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55915 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaBGVGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 16:06:47 -0500
Date: Fri, 7 Feb 2014 13:06:00 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Tejun Heo <tj@kernel.org>
cc: Hugh Dickins <hughd@google.com>,
        Filipe Brandenburger <filbranden@google.com>,
        Li Zefan <lizefan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>,
        Markus Blank-Burian <burian@muenster.de>,
        Shawn Bohrer <shawn.bohrer@gmail.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] cgroup: use an ordered workqueue for cgroup
 destruction
In-Reply-To: <20140207203508.GC8833@htj.dyndns.org>
Message-ID: <alpine.LSU.2.11.1402071300300.926@eggly.anvils>
References: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils> <20140207140402.GA3304@htj.dyndns.org> <alpine.LSU.2.11.1402071130250.333@eggly.anvils> <20140207203508.GC8833@htj.dyndns.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Feb 2014, Tejun Heo wrote:
> On Fri, Feb 07, 2014 at 12:20:44PM -0800, Hugh Dickins wrote:
> 
> > You don't return to this concern in the following mails of the thread:
> > did you later decide that it actually won't be a problem?  I'll assume
> > so for the moment, since you took the patch, but please reassure me.
> 
> I was just worrying about a different solution where we take
> css_offline invocation outside of cgroup_mutex and bumping up
> max_active.  There's nothing to worry about your patch.  Sorry about
> not being clear.  :)

Thanks a lot for your detailed and admirably responsive explanations.
You were looking ahead, I see that now, and I'm gratefully reassured :)

Hugh
