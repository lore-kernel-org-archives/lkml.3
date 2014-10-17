Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbaJQQGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 12:06:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbaJQQGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 12:06:48 -0400
Date: Fri, 17 Oct 2014 18:06:46 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + freezer-check-oom-kill-while-being-frozen.patch added to -mm
 tree
Message-ID: <20141017160645.GG8076@dhcp22.suse.cz>
References: <20141016203954.GA26336@redhat.com>
 <20141017065947.GA8076@dhcp22.suse.cz>
 <20141017153155.GB7227@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141017153155.GB7227@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 17-10-14 17:31:55, Oleg Nesterov wrote:
> On 10/17, Michal Hocko wrote:
> >
> > Can we simply make the task sleep interruptible?
> 
> No, this will turn __refrigerator() into the busy-wait loop if
> signal_pending() == T.

good point.
 
> (but I still think it makes sense to kill PF_FROZEN and introduce
>  TASK_FROZEN state, however this is offtopic).
> 
> Oleg.
> 

-- 
Michal Hocko
SUSE Labs
