Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbaK1U5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 15:57:38 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52020 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaK1U5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 15:57:37 -0500
Date: Fri, 28 Nov 2014 21:57:06 +0100
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/9] staging: panel: Use defined value or checking
 module params state
Message-ID: <20141128205705.GA8278@firebird>
References: <1416429531-11088-1-git-send-email-marius.gorski@gmail.com>
 <1416429531-11088-5-git-send-email-marius.gorski@gmail.com>
 <20141126215801.GA32756@kroah.com>
 <20141127132657.GA12298@firebird>
 <20141127152417.GB23247@kroah.com>
 <20141127155706.GB24149@kroah.com>
 <20141127195054.GA14536@firebird>
 <20141128203248.GA26878@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141128203248.GA26878@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 12:32:48PM -0800, Greg Kroah-Hartman wrote:
> On Thu, Nov 27, 2014 at 08:50:55PM +0100, Mariusz Gorski wrote:
> > On Thu, Nov 27, 2014 at 07:57:06AM -0800, Greg Kroah-Hartman wrote:
> > > On Thu, Nov 27, 2014 at 07:24:17AM -0800, Greg Kroah-Hartman wrote:
> > > > On Thu, Nov 27, 2014 at 02:26:59PM +0100, Mariusz Gorski wrote:
> > > > > On Wed, Nov 26, 2014 at 01:58:01PM -0800, Greg Kroah-Hartman wrote:
> > > > > > On Wed, Nov 19, 2014 at 09:38:46PM +0100, Mariusz Gorski wrote:
> > > > > > > Avoid magic number and use a comparison with a defined value instead
> > > > > > > that checks whether module param has been set by the user to some
> > > > > > > value at loading time.
> > > > > > > 
> > > > > > > Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
> > > > > > > Acked-by: Willy Tarreau <w@1wt.eu>
> > > > > > > ---
> > > > > > > v2: Don't introduce new macros for param value check
> > > > > > > 
> > > > > > >  drivers/staging/panel/panel.c | 86 +++++++++++++++++++++----------------------
> > > > > > >  1 file changed, 43 insertions(+), 43 deletions(-)
> > > > > > 
> > > > > > Ugh, I messed up here, and applied the first series, which was acked.
> > > > > > 
> > > > > > Mariusz, can you resend the patches that I didn't apply, I can't seem to
> > > > > > get the rest of these to work properly.
> > > > > 
> > > > > Greg, if I get you here correctly, you've applied all 9 patches from v1
> > > > > and none from v2, so what you need now is a v1->v2 patch, right?
> > > > 
> > > > No, I think I applied the patches sent _before_ the 9 series, it was 4
> > > > or 5 or so, you should have gotten an email about them.  Pull my
> > > > staging-testing branch and redo your remaining patches please.
> > > 
> > > And the reason I got confused was because you didn't label your second
> > > set of patches "v2", which it was, I saw two separate series, one with a
> > > few patches, and then 2 sets of 9, the second set labeled "v2" so I
> > > thought they were independant.  Please think of the poor maintainer who
> > > has to decipher things like this when you send them out...
> > 
> > I'm confused right now. As you say, first I've sent a patchset of 4:
> > https://lkml.org/lkml/2014/11/11/963
> 
> Which I applied.
> 
> > Then, a couple of days later, I've sent the initial patchset of 9:
> > https://lkml.org/lkml/2014/11/18/922
> > 
> > And a day I've sent a fixed version of the above patchset, labeled with v2:
> > https://lkml.org/lkml/2014/11/19/653
> 
> So I thought your series of 9 was separate from the series of 4, you can
> see my confusion (remember, I receive on _average_ about 1000 emails a day).
> 
> > Isn't this the right way to do? I still don't get my mistake. Because
> > what I was just about to do is to resend the v2 patchset, but now I'm
> > not sure anymore if this is what I'm supposed to do.
> > 
> > BTW: Out of these 3 patchsets, 1st and 3rd should be applied.
> 
> I tried to apply the 3rd, but it didn't apply due to patches I applied
> in your first set of 4 patches.
> 
> Does that help?

Yes, thanks. I've resent the patchset yesterday as v3:
https://lkml.org/lkml/2014/11/27/805

It applies cleanly to current staging-testing (aa9d9be),
I've just retested it. Please give it a try.

Thanks,
Mariusz
