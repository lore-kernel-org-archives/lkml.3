Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbaLGKN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 05:13:29 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46519 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbaLGKN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 05:13:26 -0500
Date: Sun, 7 Dec 2014 11:13:23 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH -v2 1/5] oom: add helpers for setting and clearing
 TIF_MEMDIE
Message-ID: <20141207101323.GE15892@dhcp22.suse.cz>
References: <20141110163055.GC18373@dhcp22.suse.cz>
 <1417797707-31699-1-git-send-email-mhocko@suse.cz>
 <1417797707-31699-2-git-send-email-mhocko@suse.cz>
 <20141206125617.GB18711@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141206125617.GB18711@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 06-12-14 07:56:17, Tejun Heo wrote:
> On Fri, Dec 05, 2014 at 05:41:43PM +0100, Michal Hocko wrote:
> > +/**
> > + * Marks the given taks as OOM victim.
> 
> /**
>  * $FUNCTION_NAME - $DESCRIPTION
> 
> > + * @tsk: task to mark
> > + */
> > +void mark_tsk_oom_victim(struct task_struct *tsk)
> > +{
> > +	set_tsk_thread_flag(tsk, TIF_MEMDIE);
> > +}
> > +
> > +/**
> > + * Unmarks the current task as OOM victim.
> 
> Ditto.

Fixed
-- 
Michal Hocko
SUSE Labs
