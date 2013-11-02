Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750965Ab3KBEnW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 00:43:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46015 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729Ab3KBEnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 00:43:21 -0400
Date: Sat, 2 Nov 2013 05:34:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Borislav Petkov <bp@suse.de>, suravee.suthikulpanit@amd.com,
        mingo@kernel.org, mingo@redhat.com, jacob.w.shin@gmail.com,
        oleg@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        hpa@zytor.com, linux-kernel@vger.kernel.org, sherry.hurwitz@amd.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/3] perf/x86/amd: AMD support for bp_len >
 HW_BREAKPOINT_LEN_8
Message-ID: <20131102043438.GA11257@pd.tnic>
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1380730268-25807-2-git-send-email-suravee.suthikulpanit@amd.com>
 <20131031095829.GE2253@localhost.localdomain>
 <20131031104836.GC10544@pd.tnic>
 <20131031112328.GF2253@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131031112328.GF2253@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 12:23:30PM +0100, Frederic Weisbecker wrote:
> Ok we can keep that naming then, at least on the feature symbol. But
> add a comment on it.

Great, in the latest F16h BKDG the CPUID bit is called
"DataBreakpointExtension". So BPEXT could mean anything :)

So the comment is with the definition of the bit:

+#define X86_FEATURE_BPEXT      (6*32+26) /* data breakpoint extension */

Oh well...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
