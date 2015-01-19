Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbbASCCW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 21:02:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbbASCCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 21:02:20 -0500
Date: Mon, 19 Jan 2015 09:58:37 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Tang, Feng" <feng.tang@intel.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Heesub Shin <heesub.shin@samsung.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] staging: andriod: ion: Add ion_phys_get_by_id
 function
Message-ID: <20150119015837.GA29138@kroah.com>
References: <1420355512-31129-1-git-send-email-feng.tang@intel.com>
 <20150105142433.1d892039@lxorguk.ukuu.org.uk>
 <A74E4C03C808B649AF1F11527F2D4414050FD0E1@SHSMSX101.ccr.corp.intel.com>
 <20150118000418.GA1791@kroah.com>
 <A74E4C03C808B649AF1F11527F2D44140510FC7D@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A74E4C03C808B649AF1F11527F2D44140510FC7D@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 01:14:49AM +0000, Tang, Feng wrote:
> Hi Greg,
> 
> Thanks for your review.
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Sunday, January 18, 2015 8:04 AM
> > To: Tang, Feng
> > Cc: One Thousand Gnomes; John Stultz; Colin Cross; Heesub Shin; Mitchel
> > Humpherys; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH 1/2] staging: andriod: ion: Add ion_phys_get_by_id
> > function
> >
> > > >
> > > > On Sun,  4 Jan 2015 15:11:51 +0800
> > > > Feng Tang <feng.tang@intel.com> wrote:
> > > >
> > > > > There is user case that user only knows the ion_handle idand
> > > > > needs to get the physical addr and len. So add this wrapper to
> > > > > meet this requirement.
> > > >
> > > > What is the in-tree upstream user of this new function ? I don't see one
> > > > in your patches ?
> > >
> > > That's true. We are working on enabling a new platform which heavily
> > > uses ION and some driver needs to use this API, so I guess there is some
> > > other plaforms may have the similar requirements. If you think this patch
> > > should be merged after there is an in-tree user, I'm OK with it :)
> > >
> > > I assume that driver's author will start to push his drivers in batch soon.
> > 
> > We need to see those patches first, we can't add apis for no in-tree
> > user, otherwise they will just get ripped out.
> I see. I'll repost this patch after our "user" driver get merged.
> 
> How about the 2/2 patch, which improve the profiling info through
> debugfs?
> 	[PATCH 2/2] staging: android: ion: Add pss info for each ion_client

I don't see it in my queue anywhere, sorry, feel free to resend it.

thanks,

greg k-h
