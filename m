Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab3HULaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 07:30:19 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:55681 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3HULaR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 07:30:17 -0400
Date: Wed, 21 Aug 2013 02:04:17 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH v3 trivial 0/7] Miscellaneous Trivialities
To: Michael Witten <mfwitten@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
In-Reply-To: <0f201a86cef14399a093518c2743856f-mfwitten@gmail.com> (from
	mfwitten@gmail.com on Tue Aug 20 22:32:02 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1377068657.2737.90@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 10:32:02 PM, Michael Witten wrote:
> On Tue, 20 Aug 2013 19:19:37 -0500, Rob Landley wrote:
> 
> > Hence asking if we really needed
> > three separate commits to accomplish something that didn't actually
> > need to be done in the first place.)
> > ...
> > Actually my objection is that it's not worth the churn in the  
> commit logs.
> 
> Naturally, we don't NEED three separate commits! Squash all of them
> into one commit if that's something worth hissing about.
> 
> Do you need help with the relevant commands?

The correct response to someone disagreeing you is to patronize them?

Query: did you notice the phrase "something that didn't actually need  
to be done in the first place"? You quoted it and everything, so I'm  
assuming you ignored it intentionally rather than simply not noticing.

> Because you are the former and current maintainer of large and active
> projects, I'd expect you to *appreciate* the value of taking in
> fine-grained patches for REVIEW (even if you don't appreciate their
> sum total).

I reviewed them. The result of that review is what you're objecting to.

> The patches have been written in a way to *ease* the job of the
> maintainer in understanding the changes.

My understanding is that they're pointless churn.

> The fact that you find each
> patch ludicrously trivial is a GREAT sign, especially considering
> that I sent them mainly to the maintainer of... *TRIVIAL* changes.

1) Not everything trivial is worth doing.

2) "A maintainer's job is to say no." - Alan Cox

> > But yeah, why would a guy listed in MAINTAINERS as caring about the
> > Documentation directory pay attention to proposed changes to the
> > Documentation directory? Madness. I'll butt out now...
> 
> Madness is thinking that it means something to have your name listed  
> in
> some file.

Huh. Oddly specific definition. Has anyone informed the psychiatric  
profession?

> You are the maintainer when people send you patches and pull
> from your repo---that is, when people *like* working with you. That's  
> it.
> A name in a file is simply a starting point for those contributors who
> may not know any better.

I only brought it up becauase you were objecting to me butting my nose  
into your affairs.

> Don't take "your" position for granted.

Obviously when someone disagrees with you, threatening to get them  
fired will immediately convince them of the virtue of your position. (I  
presume this is how you handle restaurants as well?)

You misunderstand the nature of the position: this is volunteer  
janitorial work. I don't get paid for it, and haven't even bothered to  
list the maintainership on my resume. (Programmers get paid more than  
tech writers.) I'd be pretty _happy_ to find somebody else willing to  
do a better job at it. (I'd also love somebody to start up  
kernel-traffic or the kernel podcast again, restart h-online, re-enable  
rsync support in kernel.org...) I have way too many demands on my time,  
but was _asked_ by the previous guy to take over when he didn't have  
time anymore. I've been trying to carve out more time to clean up the  
directory (in a librarian sort of way; didn't write the books but I can  
shelve them more neatly), but free time seems to be self-consuming  
these days...

None of this changes my opinion that your first three changes are  
pointless churn, a waste of time, and not worth merging. (Your  
indignant and self-important reaction to that evaluation _has_ changed  
my opinion of your technical judgement and likelihood of listening to  
you in the future, so that's something.)

Nothing stops one of the other maintainers from taking your patch over  
my objections. Most documentation goes in through other trees anyway,  
generally as part of series with code and documentation components. But  
_my_ evaluation remains "NAK".

Rob