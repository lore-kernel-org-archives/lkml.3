Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaILV3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:29:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaILV3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:29:19 -0400
Date: Fri, 12 Sep 2014 14:29:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Matt <jackdachef@gmail.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: linux-3.16.2 queue (3.16.1+)
Message-ID: <20140912212918.GA9690@kroah.com>
References: <CAG-aW06Q9VVyW-atZEsURs0rfjysdEbxb_dC4Tm3K-tZg++tQg@mail.gmail.com>
 <20140828152205.GA18432@kroah.com>
 <CAG-aW05qkQKgntBM87XHSMECjD-GMjeRt+m0-0CkezBG_weCOg@mail.gmail.com>
 <20140828153252.GA18868@kroah.com>
 <CAG-aW07Lx=WOEf+j=_+G5T57uzhvKiP3-ZpaadKvoafW=iJKrw@mail.gmail.com>
 <CAG-aW04YvZVxKBhSAYqhr5OBFovA3HHHWgdfEQU_jXKzQK7QdA@mail.gmail.com>
 <20140907031814.GA961@kroah.com>
 <5411252A.1030901@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5411252A.1030901@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 12:29:30AM -0400, Jeff Mahoney wrote:
> On 9/6/14, 11:18 PM, Greg KH wrote:
> > On Sun, Sep 07, 2014 at 02:47:55AM +0200, Matt wrote:
> >> On Thu, Aug 28, 2014 at 9:18 PM, Matt <jackdachef@gmail.com>
> >> wrote:
> >>> On Thu, Aug 28, 2014 at 5:32 PM, Greg KH
> >>> <gregkh@linuxfoundation.org> wrote:
> >>>> On Thu, Aug 28, 2014 at 05:27:27PM +0200, Matt wrote:
> >>>>> On Thu, Aug 28, 2014 at 5:22 PM, Greg KH
> >>>>> <gregkh@linuxfoundation.org> wrote:
> >>>>>> On Thu, Aug 28, 2014 at 05:16:58PM +0200, Matt wrote:
> >>>>>>> Hi Greg,
> >>>>>>> 
> >>>>>>> 
> >>>>>>> please consider adding the following 2 patches to
> >>>>>>> 3.16.2:
> >>>>>>> 
> >>>>>>> Jan Kara (1): reiserfs: Fix use after free in journal
> >>>>>>> teardown
> >>>>>>> 
> >>>>>>> Jeff Mahoney (1): reiserfs: fix corruption introduced
> >>>>>>> by balance_leaf refactor
> >>>>>>> 
> >>>>>>> 
> >>>>>>> 
> >>>>>>> Reason/Related:
> >>>>>>> 
> >>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=83121
> >>>>>>> 
> >>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=83321
> >>>>>>> 
> >>>>>>> http://forums.gentoo.org/viewtopic-t-998538-postdays-0-postorder-asc-start-0.html
> >>>>>>>
> >>>>>>>
> >>>>>>>
> >>>>>>> 
> Many thanks in advance
> >>>>>> 
> >>>>>> I need git commit ids of these patches in Linus's tree,
> >>>>>> can you provide those please?
> >>>>>> 
> >>>>>> thanks,
> >>>>>> 
> >>>>>> greg k-h
> >>>>> 
> >>>>> 
> >>>>> Sure:
> >>>>> 
> >>>>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=27d0e5bc85f3341b9ba66f0c23627cf9d7538c9d
> >>>>>
> >>>>> 
> reiserfs: fix corruption introduced by balance_leaf refactor
> >>>>> 
> >>>>> 
> >>>>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=01777836c87081e4f68c4a43c9abe6114805f91e
> >>>>>
> >>>>> 
> reiserfs: Fix use after free in journal teardown
> >>>>> 
> >>>>> 
> >>>>> 
> >>>>> are checkpatch warnings usually also fixed within stable
> >>>>> releases ?
> >>>> 
> >>>> No, not at all, please read
> >>>> Documentation/stable_kernel_patches.txt for what is
> >>>> acceptable for stable kernel patches.
> >>>> 
> >>>> thanks,
> >>>> 
> >>>> greg k-h
> >>> 
> >>> 
> >>> okay, will do
> >>> 
> >>> thanks for pointing that out
> >>> 
> >>> 
> >>> Regards
> >>> 
> >>> Matt
> >> 
> >> Hi Greg,
> >> 
> >> could you please add the above mentioned two patches
> >> 
> >> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=27d0e5bc85f3341b9ba66f0c23627cf9d7538c9d
> >>
> >> 
> reiserfs: fix corruption introduced by balance_leaf refactor
> >> 
> >> 
> >> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=01777836c87081e4f68c4a43c9abe6114805f91e
> >>
> >> 
> reiserfs: Fix use after free in journal teardown
> >> 
> >> in next stable (3.16.3) kernel ?
> >> 
> >> more and more people seem to be affected by the data corruption 
> >> introduced by the recent changes.
> >> 
> >> 
> >> Reading through Documentation/stable_kernel_rules.txt, 
> >> http://cwe.mitre.org/data/definitions/416.html and 
> >> http://www.hpenterprisesecurity.com/vulncat/en/vulncat/cpp/use_after_free.html
> >>
> >>
> >> 
> both patches seem relevant enough (concerning data integrity
> >> filesystem-wise and security) to be included for the stable
> >> branch
> > 
> > I'll queue this up when I get a chance, there are over 300 patches 
> > pending for the stable kernels right now :(
> > 
> > Also, in the future, always cc stable@vger.kernel.org for any
> > stable requests so that they don't get lost.
> 
> Hi Greg -
> 
> 27d0e5bc85f3341b9ba66f0c23627cf9d7538c9d
> Author: Jeff Mahoney <jeffm@suse.com>
> Date:   Mon Aug 4 19:51:47 2014 -0400
> 
>     reiserfs: fix corruption introduced by balance_leaf refactor
> 
>     Commits f1f007c308e (reiserfs: balance_leaf refactor, pull out
>     balance_leaf_insert_left) and cf22df182bf (reiserfs: balance_leaf
>     refactor, pull out balance_leaf_paste_left) missed that the `body'
>     pointer was getting repositioned. Subsequent users of the pointer
>     would expect it to be repositioned, and as a result, parts of the
>     tree would get overwritten. The most common observed corruption
>     is indirect block pointers being overwritten.
> 
>     Since the body value isn't actually used anymore in the called
> routines,
>     we can pass back the offset it should be shifted. We constify the body
>     and ih pointers in the balance_leaf as a mostly-free preventative
> measure.
> 
>     Cc: <stable@vger.kernel.org> # 3.16
>     Reported-and-tested-by: Jeff Chua <jeff.chua.linux@gmail.com>
>     Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>     Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Should there have been more? I thought it was enough to add the Cc
> tag. This one has been in the tree, with the tags and with
> "corruption" in the Subject since 13 Aug. I know you're busy but this
> seems like a pretty obvious candidate for stable inclusion.

You marked this one just fine, it's just that, again, I have over 300+
patches in the "marked for stable" queue right now, this patch is in
good company...

greg k-h
