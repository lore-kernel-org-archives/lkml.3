Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740AbaLJOsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:48:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbaLJOsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:48:31 -0500
Date: Wed, 10 Dec 2014 09:48:29 -0500
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Dexuan Cui <decui@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] Tools: hv: fix compiler warnings and do minor cleanup
Message-ID: <20141210144829.GB17184@kroah.com>
References: <1418140103-11854-1-git-send-email-vkuznets@redhat.com>
 <F792CF86EFE20D4AB8064279AFBA51C613E9B62F@SIXPRD3002MB028.064d.mgd.msft.net>
 <87lhmfhna7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lhmfhna7.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 10:22:40AM +0100, Vitaly Kuznetsov wrote:
> Dexuan Cui <decui@microsoft.com> writes:
> 
> >> -----Original Message-----
> >> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> >> Sent: Tuesday, December 9, 2014 23:48 PM
> >> To: KY Srinivasan
> >> Cc: Haiyang Zhang; devel@linuxdriverproject.org; linux-
> >> kernel@vger.kernel.org; Dexuan Cui
> >> Subject: [PATCH 0/5] Tools: hv: fix compiler warnings and do minor cleanup
> >> 
> >> When someone does 'make' in tools/hv/ issues appear:
> >> - hv_fcopy_daemon is not being built;
> >> - lots of compiler warnings.
> >> 
> >> This is just a cleanup. Compile-tested by myself on top of linux-next/master.
> >> 
> >> Piggyback this series and send "[PATCH 5/5] Tools: hv: do not add redundant
> >> '/'
> >>  in hv_start_fcopy()"
> >> 
> >> Vitaly Kuznetsov (5):
> >>   Tools: hv: add mising fcopyd to the Makefile
> >>   Tools: hv: remove unused bytes_written from kvp_update_file()
> >>   Tools: hv: address compiler warnings for hv_kvp_daemon.c
> >>   Tools: hv: address compiler warnings for hv_fcopy_daemon.c
> >>   Tools: hv: do not add redundant '/' in hv_start_fcopy()
> >> 
> >>  tools/hv/Makefile          |  4 ++--
> >>  tools/hv/hv_fcopy_daemon.c | 10 ++--------
> >>  tools/hv/hv_kvp_daemon.c   | 29 +++++++++++++----------------
> >>  3 files changed, 17 insertions(+), 26 deletions(-)
> >> 
> >> --
> >> 1.9.3
> >
> > Hi Vitaly,
> > Thanks for the patchset!
> >
> > Acked-by: Dexuan Cui <decui@microsoft.com>
> >
> > PS, I added Greg into the TO list.
> > The hv code in drivers/hv/ and tools/hv/ usually has to go into
> > Greg's tree first.
> 
> Well, I don't mind spamming Greg but he's not on the
> scripts/get_maintainer.pl output. In case he's not monitoring the list
> for patches by some other tool (patchwork?) a patch adding him to
> MAINTAINERS would do the job.
> 
> Greg, do you want to become an official Hyper-V maintainer in
> MAINTAINERS? I can send a patch then :-)

No.  It's up to the "real" maintainers to take the patches and then
forward them on to me for inclusion in the kernel tree.  KY knows
this...

thanks,

greg k-h
