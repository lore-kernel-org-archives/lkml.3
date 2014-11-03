Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbaKCVew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:34:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54042 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbaKCVeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:34:50 -0500
Date: Mon, 3 Nov 2014 22:34:43 +0100
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: arapov@gmail.com, poros@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, matt@console-pimps.org
Subject: Re: FW/BIOS Bug category for oops.kernel.org
Message-ID: <20141103213442.GB27387@pd.tnic>
References: <20141103212610.GA10501@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141103212610.GA10501@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 10:26:10PM +0100, Peter Zijlstra wrote:
> Hi oops.kernel.org folks,
> 
> I'm wanting to collect information on FW/BIOS bugs, and I figured that
> we could use the oops.kernel.org infrastructure to do this.
> 
> Now, I'd prefer to not use the regular BUG/WARN because it might confuse
> users and the stacktrace is entirely pointless -- we know were/why we
> generate the msgs.
> 
> Is everything between:
> 
>         pr_warn("------------[ cut here ]------------\n");
> and:
>         pr_warn("---[ end trace %016llx ]---\n", (unsigned long long)oops_id);
> 
> sucked in automagically, or do we need more magic?

Btw, we have FW_{BUG,WARN,INFO} macros for exactly firmware issues.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
