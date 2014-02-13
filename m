Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaBMAjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 19:39:20 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:50351 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaBMAjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 19:39:18 -0500
Date: Wed, 12 Feb 2014 16:38:25 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Tejun Heo <tj@kernel.org>
cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Filipe Brandenburger <filbranden@google.com>,
        Li Zefan <lizefan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>,
        Markus Blank-Burian <burian@muenster.de>,
        Shawn Bohrer <shawn.bohrer@gmail.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] cgroup: bring back kill_cnt to order css
 destruction
In-Reply-To: <20140213002853.GC2916@htj.dyndns.org>
Message-ID: <alpine.LSU.2.11.1402121636290.5728@eggly.anvils>
References: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils> <20140207164321.GE6963@cmpxchg.org> <alpine.LSU.2.11.1402121417230.5029@eggly.anvils> <alpine.LSU.2.11.1402121504150.5029@eggly.anvils> <20140213002853.GC2916@htj.dyndns.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb 2014, Tejun Heo wrote:
> 
> Not that your implementation is bad or anything but the patch itself
> somehow makes me cringe a bit.  It's probably just because it has to
> add to the already overly complicated offline path.  Guaranteeing
> strict offline ordering might be a good idea but at least for the
> immediate bug fix, I agree that the memcg specific fix seems better
> suited.  Let's apply that one and reconsider this one if it turns out
> we do need strict offline reordering.

Yes, I agree completely - thanks.

Hugh
