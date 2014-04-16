Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbaDPJx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:53:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:44846 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751691AbaDPJxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:53:53 -0400
Date: Wed, 16 Apr 2014 05:53:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Richard Weinberger <richard@nod.at>
Cc: Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        ak@linux.intel.com, Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: CPU: 2 PID: 1857 at arch/x86/kernel/smp.c:124
Message-ID: <20140416055350.5301cb7e@gandalf.local.home>
In-Reply-To: <534E4D48.5050002@nod.at>
References: <534E49C8.7050206@nod.at>
	<20140416092146.GQ11182@twins.programming.kicks-ass.net>
	<534E4D48.5050002@nod.at>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2014 11:28:40 +0200
Richard Weinberger <richard@nod.at> wrote:

> Am 16.04.2014 11:21, schrieb Peter Zijlstra:
> > On Wed, Apr 16, 2014 at 11:13:44AM +0200, Richard Weinberger wrote:
> >> Hi!
> >>
> >> On a new 8 core server I'm facing the following issue.
> >> After an oops a warning triggers.
> > 
> > I think its fair to ignore everything _after_ an OOPS ;-)
> 
> The problem here is that I'm using pstore with the erst backend (ACPI APEI).
> But it can only store a few KiB. So upon every oops it captures only the bogus
> warning and the original one is lost.

You should change that so the recording to pstore is disabled after the
first oops.

-- Steve
