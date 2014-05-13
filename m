Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaEMFKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 01:10:44 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56577 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaEMFKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 01:10:43 -0400
Date: Tue, 13 May 2014 10:40:34 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Denys Vlasenko <dvlasenk@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, David Long <dave.long@linaro.org>
Subject: Re: [PATCH 0/1] (Was: cleanup DO_ERROR*() to prepare for uprobes
 fixes)
Message-ID: <20140513051034.GB11996@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20140508191140.GA16892@redhat.com>
 <20140512170822.GA28335@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512170822.GA28335@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051305-6688-0000-0000-000001C50AB9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 07:08:22PM +0200, Oleg Nesterov wrote:
> On 05/08, Oleg Nesterov wrote:
> >
> > But let me send the initial changes first for review. If they pass the review
> > and if nobody objects, I'd like to route them along with the pending uprobes
> > fixes.
> 
> OK, nobody cares ;)
> 
> So I am going to ask Ingo to pull these changes plus the following minor fix.
> 
> To remind, I think that traps.c needs more cleanups: do_general_protection()
> and math_error() should be converted into DO_ERROR(), DIE_GPF should die, and
> the users of show_unhandled_signals() should be unified/cleanuped.
> 
> Ananth, David, this is x86 specific, but at first glance powerpc/arm might
> want to use uprobe_get_trap_addr() too.

Thanks for the heads-up Oleg.

Ananth

