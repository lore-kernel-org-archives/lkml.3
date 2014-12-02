Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaLBI7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:59:53 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:50534 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaLBI7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:59:52 -0500
Date: Tue, 2 Dec 2014 09:59:49 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: oom && coredump
Message-ID: <20141202085949.GA27014@dhcp22.suse.cz>
References: <20141017171904.GA12263@redhat.com>
 <20141020184657.GA505@dhcp22.suse.cz>
 <20141020190620.GA21882@redhat.com>
 <20141020195618.GA606@redhat.com>
 <20141127122908.GB18833@dhcp22.suse.cz>
 <20141127174747.GA7684@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127174747.GA7684@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 27-11-14 18:47:47, Oleg Nesterov wrote:
> On 11/27, Michal Hocko wrote:
[...]
> > Why is the ptrace check wrong?
> 
> It was added in reply to exploit I sent. But:
> 
> - It doesn't (and can't) really work, it can only detect this particular
>   case and the same exploit still blocks oom-killer with the minimal
>   modifications.
> 
> - Once again, this has nothing to do with ptrace. That exploit used
>   ptrace only to control (freeze) the coredumping process, the coredumping
>   can "hang" because of other reasons.
> 
> - It is no longer needed after this patch, the coredumping process will
>   be killed.

OK, I guess I am seeing it now. Thanks for the clarification!

[...]
-- 
Michal Hocko
SUSE Labs
