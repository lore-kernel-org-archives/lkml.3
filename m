Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030922AbaLMNdc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 08:33:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55480 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030889AbaLMNdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 08:33:31 -0500
Date: Sat, 13 Dec 2014 14:33:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <marc.zyngier@arm.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH 2/2] tracing: Add tracepoint_printk cmdline
Message-ID: <20141213133323.GC29934@pd.tnic>
References: <alpine.DEB.2.11.1412121539300.16494@nanos>
 <20141212181420.47100d5c@gandalf.local.home>
 <20141213004830.792da019@gandalf.local.home>
 <20141213005037.78eca245@gandalf.local.home>
 <20141213105925.GB29934@pd.tnic>
 <20141213081832.05cb4e6b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141213081832.05cb4e6b@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 08:18:32AM -0500, Steven Rostedt wrote:
> > tp_printk
> 
> Actually, I was thinking about shortening it to tp_printk.

Yeah, this is probably the best alternative.

> What you need when your kernel is in the crapper.

Haha, yeah.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
