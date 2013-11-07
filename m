Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3KGHs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 02:48:26 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:40313 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab3KGHsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 02:48:17 -0500
Date: Thu, 7 Nov 2013 08:48:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: preparations for arm port
Message-ID: <20131107074811.GA31560@gmail.com>
References: <20131106191913.GA18661@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106191913.GA18661@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

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
>  arch/powerpc/include/asm/uprobes.h |    8 +-------
>  arch/x86/include/asm/uprobes.h     |   12 ++++--------
>  include/linux/uprobes.h            |    9 +++++++++
>  kernel/events/uprobes.c            |   24 ++++++++++--------------
>  4 files changed, 24 insertions(+), 29 deletions(-)

Pulled into tip:perf/core, thanks a lot Oleg!

	Ingo
