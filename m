Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaFBGEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 02:04:51 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:39110 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaFBGEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 02:04:50 -0400
Date: Mon, 2 Jun 2014 11:34:40 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Denys Vlasenko <dvlasenk@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes/x86: Rename arch_uprobe->def into ->dflt, minor
 comment updates
Message-ID: <20140602060440.GD2447@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140601192520.GA14539@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140601192520.GA14539@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060206-3568-0000-0000-0000059B275B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2014-06-01 21:25:20]:

> Purely cosmetic, no changes in .o,
> 
> 1. As Jim pointed out arch_uprobe->def looks ambiguous, rename it to
>    ->dflt.
> 
> 2. Add the comment into default_post_xol_op() to explain "regs->sp +=".
> 
> 3. Remove the stale part of the comment in arch_uprobe_analyze_insn().
> 
> Suggested-by: Jim Keniston <jkenisto@us.ibm.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju

