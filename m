Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab3KIATb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 19:19:31 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:36296 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab3KIAT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 19:19:29 -0500
X-Originating-IP: 173.246.103.110
Date: Fri, 8 Nov 2013 16:19:18 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the akpm-current tree with the tip
 tree
Message-ID: <20131109001917.GA25715@jtriplet-mobl1>
References: <20131108184805.ec16e3b5cc08834cb5d4f812@canb.auug.org.au>
 <20131108185812.GB11311@jtriplet-mobl1>
 <20131109102058.4edc71a4a367d3d6c92844aa@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109102058.4edc71a4a367d3d6c92844aa@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 10:20:58AM +1100, Stephen Rothwell wrote:
> Hi Josh,
> 
> On Fri, 8 Nov 2013 10:58:12 -0800 Josh Triplett <josh@joshtriplett.org> wrote:
> >
> > Won't splitting the Makefile change into a separate commit break
> > bisection, in particular if you have the changes adding inlines but you
> > also compile in lglock.o?  Shouldn't this be squashed into the merge
> > itself, keeping the kernel/Makefile section of my original patch?
> 
> Actually it is not a problem because that fix patch was applied to the
> merge commit between the part of Andrew's tree that depends only on
> Linus' tree and the rest of linux-next.  So each side of the merge is ok
> and the merge commit itself fixes up the conflict.
> 
> I just split it this way for my work flow purposes.

Ah, I see.  That wasn't obvious to me from your previous mail explaining
your fix. :)

- Josh Triplett
