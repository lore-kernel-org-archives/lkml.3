Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935471Ab3DHMBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:01:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42004 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935449Ab3DHMBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:01:41 -0400
Date: Mon, 8 Apr 2013 13:59:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: x86/mm/pageattr: Code without effect?
Message-ID: <20130408115959.GB4395@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Stefan Bader <stefan.bader@canonical.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Whitcroft <apw@canonical.com>, Mel Gorman <mgorman@suse.de>
References: <515E92CE.2000509@canonical.com>
 <20130405142104.GB29290@pd.tnic>
 <20130406145804.GJ3423@redhat.com>
 <20130406154751.GB3612@pd.tnic>
 <20130408115344.GA7513@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130408115344.GA7513@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 01:53:44PM +0200, Ingo Molnar wrote:
> 
> * Borislav Petkov <bp@alien8.de> wrote:
> 
> > > have been the source of the confusion. Remove the noop initialization
> > > accordingly.
> > > 
> > > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> > 
> > Yeah, looks good to me. I've folded it into my pile of changes touching this and 
> > there are no visible issues. [...]
> 
> Logistics question: is this fix coming upstream-wards via your pile of changes 
> anytime soon?

Actually I was thinking Andrea would send it since it is his fix. And
besides, my pile is still stinking. :-)

AFAICT, the patch fixes a noop so the current code works anyway - IOW,
it is basically a code correctness fix which doesn't have any other
effect. What I mean by that is, no need to go in now for 3.9 and stable.

Long story, short: best it would be, IMO, if Andrea would send it to
you soonish but you apply it for 3.10 so that it sees a whole cycle of
testing just in case - it is CPA code after all.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
