Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751001Ab3KGFjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:39:46 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56543 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab3KGFjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:39:45 -0500
Date: Thu, 7 Nov 2013 11:06:41 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: preparations for arm port
Message-ID: <20131107053641.GC26744@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131106191913.GA18661@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131106191913.GA18661@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110705-5806-0000-0000-000023583E9A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-11-06 20:19:13]:

> Ingo, please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core
> 
> 
> I have also attached the cumulative diff below. As you can see,
> the changes are really simple and there are no functional changes.
> 
> However I think it makes sense to merge this now, this way the
> upcoming arm port doesn't (almost) need the changes outside of
> arch/arm and thus it would be simpler to route everything via
> arm trees.
> 
> 
> David A. Long (1):
>       uprobes: Move function declarations out of arch
> 
> Oleg Nesterov (3):
>       uprobes: Kill module_init() and module_exit()
>       uprobes: Introduce arch_uprobe->ixol
>       uprobes: Export write_opcode() as uprobe_write_opcode()
> 

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
for this series.

-- 
Thanks and Regards
Srikar Dronamraju

