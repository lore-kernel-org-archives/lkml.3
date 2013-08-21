Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab3HUATk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:19:40 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:48979 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3HUATj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:19:39 -0400
Date: Tue, 20 Aug 2013 19:19:37 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH v3 trivial 0/7] Miscellaneous Trivialities
To: Michael Witten <mfwitten@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
In-Reply-To: <6a1db75a9ce0483b94e4c6b2989e547b-mfwitten@gmail.com> (from
	mfwitten@gmail.com on Tue Aug 20 17:27:53 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1377044377.2737.87@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 05:27:53 PM, Michael Witten wrote:
> On Tue, 20 Aug 2013 16:20:02 -0500, Rob Landley wrote:
> > On 08/20/2013 11:02:42 AM, Michael Witten wrote:
> >> I've been sitting on some trivial patches for a while, and I'd just
> >> like to get them out of the way.
> >>
> >> Here is the series:
> >>
> >>   [1] Docs: Kconfig: For readability, offset modifiers with commas
> >>   [2] Docs: Kconfig: Use consistent whitespace indentation
> >>   [3] Docs: Kconfig: Clean up the radiotap documentation
> >
> > Not a single worthwhile change in any of those three.
> >
> > Excuse me:
> >
> > Not a single, worthwhile change, in any of those three.
> 
> Actually, your second attempt doesn't use commas properly.

Sorry, forgot the <shatner> tags. (Or possibly <sarcasm>.)

> In any case, this is *trivial*, miscellaneous work. I do not pretend
> to be making a major contribution; this is why I sent these patches  
> `To:'
> 
>   Jiri Kosina <TRIVIAL@kernel.org>
> 
> Other people are included as some kind of courtesy, and also so that
> any change that is actually non-trivial might be caught (as with the
> `hotplug' patch).

If you were modifying the vfs would you cc the VFS maintainer as a  
"courtesy" too?

> >>   [4] Docs: Kconfig: `devlopers' -> `developers'
> >
> > Sure, a typo, why not.
> 
> When does a series of *trivial* changes become worthwhile? What's  
> wrong
> with making refinements when it costs nothing? Must one always hide
> trivial alterations inside something more substantial?

Because some people actually read the commit logs and changes that  
don't do anything add noise for no benefit? (Your fourth change was a  
single typo fix. The previous three changes _combined_ were less  
valuable than that single typo fix. Hence asking if we really needed  
three separate commits to accomplish something that didn't actually  
need to be done in the first place.)

> All right. I get it; you personally don't give a damn. I certainly
> don't hold that against you. However, there *are* people who *do*
> care about such refinements, and a nasty, condescending email
> isn't going to alter our behavior.

Actually my objection is that it's not worth the churn in the commit  
logs.

But yeah, why would a guy listed in MAINTAINERS as caring about the  
Documentation directory pay attention to proposed changes to the  
Documentation directory? Madness. I'll butt out now...

Rob